//
//  NetworkGateway.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class NetworkGateway {
    fileprivate let fireDB: Firestore
    fileprivate lazy var keychain: KeychainAccessing = KeychainStorage(userID)

    init() {
        fireDB = Firestore.firestore()
        let settings = fireDB.settings
        settings.areTimestampsInSnapshotsEnabled = true
        fireDB.settings = settings
    }
}

extension NetworkGateway { // Common properties and methods
    var userID: String {
        if let currentUserId = Auth.auth().currentUser?.uid {
            return currentUserId
        } else if let sharedContainer = UserDefaults(suiteName: AccessGroup.default),
            let containerUserId = sharedContainer.string(forKey: UserDefaultsKey.userID) {
            return containerUserId
        } else {
            fatalError("No current user.")
        }
    }

    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void)) {
        fireDB.collection("users").document(userID).collection("accounts")
            .getDocuments { [weak self] snapshot, error in
                do {
                    guard let this = self else {
                        throw ReferenceError.type(self)
                    }

                    if let error = error {
                        throw error
                    }

                    let accounts: [Account] = try snapshot!.documents.compactMap { snapshot -> Account in
                        let json = snapshot.data()
                        return try Account(json: json)
                    }

                    guard accounts.count < this.keychain.accountsMax else {
                        throw AccountError.maximumReached
                    }

                    guard !accounts.contains(account) else {
                        throw AccountError.duplicate(accounts.first?.username)
                    }

                    this.fireDB.collection("users").document(this.userID).collection("accounts")
                        .addDocument(data: account.json as! [String: Any]) { error in // swiftlint:disable:this force_cast
                            if let error = error {
                                result(.failure(error))
                                return
                            }

                            result(.success(account))
                    }
                } catch {
                    result(.failure(error))
                }
        }
    }
}

extension NetworkGateway: AppDelegateAccessing {
    func signIn(withEmailSignupLink link: String, completion: @escaping ((Result<Bool, Error>) -> Void)) {
        guard let accountEmail = UserDefaults.standard.string(forKey: UserDefaultsKey.accountEmail) else {
            // TODO: - Add some custom error.
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            return
        }

        Auth.auth().signIn(withEmail: accountEmail, link: link) { _, error in
            guard error == nil else { completion(.failure(error!)); return }
            completion(.success(true))
        }
    }
}

extension NetworkGateway: AuthAccessing {
    func signIn(withEmail email: String, completion: @escaping ((Error?) -> Void)) {
        let bundleId = Bundle.main.bundleIdentifier!
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://collection.page.link")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(bundleId)
        actionCodeSettings.setAndroidPackageName(bundleId, installIfNotAvailable: false, minimumVersion: "12")
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings, completion: completion)
    }
}

extension NetworkGateway: AccountsAccessing {
    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void)) {
        fireDB.collection("users").document(userID).collection("accounts")
            .getDocuments { snapshot, error in
                guard error == nil else { result(.failure(error!)); return }
                do {
                    let accounts: [Account] = try snapshot!.documents.compactMap { snapshot -> Account in
                        let json = snapshot.data()
                        return try Account(json: json)
                    }
                    result(.success(accounts))
                } catch {
                    result(.failure(error))
                }
        }
    }

    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void)) {
        fireDB.collection("users").document(userID).collection("accounts").whereField("username", isEqualTo: account.username)
            .getDocuments { snapshot, error in
                guard error == nil else { result(.failure(error!)); return }
                guard let doc = snapshot?.documents.first else {
                    // TODO: - Add custom error OR create a better user management system.
                    let error = NSError(domain: "No document with username \(account.username)", code: 0, userInfo: nil)
                    result(.failure(error))
                    return
                }

                doc.reference.delete { error in
                    guard error == nil else { result(.failure(error!)); return }
                    result(.success)
                }
            }
    }

    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void)) {
        // TODO: - Refactor this so that the server gets the users list
        fireDB.collection("users").document(userID).collection("accounts")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else {
                    let error = NSError(domain: "No reference to self", code: 0, userInfo: nil)
                    result(.failure(error))
                    return
                }

                guard error == nil else { result(.failure(error!)); return }
                do {
                    let accounts: [Account] = try snapshot!.documents.compactMap { snapshot -> Account in
                        let json = snapshot.data()
                        return try Account(json: json)
                    }

                    // TODO: - START_CLEANUP {
                    let urlString = "https://tiptoe-grids.firebaseapp.com/crawl"
                    //let urlString = "http://0.0.0.0:8080/crawl"
                    guard let url = URL(string: urlString) else {
                        // TODO: - Add custom error.
                        result(.failure(NSError(domain: "URL could be initialized", code: 0, userInfo: nil)))
                        return
                    }

                    let accountUsernames = accounts.map { $0.username }
                    let parameterDictionary: [String: Any] = [
                        "accounts": accountUsernames,
                        "user_id": self.userID
                    ]

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameterDictionary)

                    guard self.keychain.creditsCount > 0 else {
                        throw NSError(domain: "No credits left", code: 0, userInfo: nil)
                    }

                    try self.keychain.updateCredits(self.keychain.creditsCount - 1)

                    let task = URLSession.shared.dataTask(with: request) { _, response, error in
                        guard error == nil else { result(.failure(error!)); return }
                        guard let httpResponse = response as? HTTPURLResponse else {
                            // TODO: - Add custom error.
                            result(.failure(NSError(domain: "Response is not a HTTPURLResponse", code: 0, userInfo: nil)))
                            return
                        }

                        guard httpResponse.isSuccessCode else {
                            // TODO: - Add custom error.
                            result(.failure(NSError(domain: "Error status code \(httpResponse.statusCode)", code: 0, userInfo: nil)))
                            return
                        }

                        result(.success)
                    }

                    task.resume()
                    // } - END_CLEANUP

                } catch {
                    result(.failure(error))
                }
        }
    }
}

extension NetworkGateway: SearchAccessing {
    func loadPosts(after date: Date, result: @escaping ((Result<[Post], Error>) -> Void)) {
        let unixTimestamp = date.timeIntervalSince1970

        // TODO: - Add enum for Collection string values
        fireDB.collection("users").document(userID).collection("posts").whereField("timestamp", isGreaterThan: unixTimestamp)
            .getDocuments { snapshots, error in
                guard error == nil else { result(.failure(error!)); return }
                do {
                    let posts: [Post] = try snapshots!.documents.compactMap { snapshot -> Post in
                        let json = snapshot.data()
                        return try Post(json: json)
                    }
                    result(.success(posts))
                } catch {
                    result(.failure(error))
                }
        }
    }
}

extension NetworkGateway: SaveAccountAccessing {
    func getInstagramEmbedded(fromURL url: URL, result: @escaping ((Result<InstagramEmbedded, Error>) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let error = error { throw error }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.isSuccessCode else { throw URLError(.badServerResponse) }
                guard let data = data else { throw NSError(domain: "No data", code: 0, userInfo: nil) }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                let instagramEmbedded = try InstagramEmbedded(json: json)
                result(.success(instagramEmbedded))
            } catch {
                result(.failure(error))
            }
        }

        task.resume()
    }
}

extension NetworkGateway: SettingsAccessing {
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

extension NetworkGateway: PostDetailAccessing {}
extension NetworkGateway: OnboardAccessing {}
