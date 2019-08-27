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

    init() {
        fireDB = Firestore.firestore()
    }
}

extension NetworkGateway { // Common properties and methods
    var userID: String {
        if let currentUserId = Auth.auth().currentUser?.uid {
            return currentUserId
        } else if let containerUserId = UserDefaults.accessGroup.string(forKey: UserDefaultsKey.userID) {
            return containerUserId
        } else {
            fatalError("No current user.")
        }
    }

    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void)) {
        fireDB.collection("users").document(userID).collection("accounts")
            .getDocuments { [weak self] snapshot, error in
                do {
                    if let error = error { throw error }
                    guard let this = self else { throw ReferenceError.type(self) }

                    let accounts: [Account] = try snapshot!.documents.compactMap { snapshot -> Account in
                        let json = snapshot.data()
                        return try Account(json: json)
                    }

                    guard !accounts.contains(account) else { throw AccountError.duplicate(accounts.first?.username) }
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
    func signIn(withEmailSignupLink link: String, result: @escaping ((Result<Void, Error>) -> Void)) {
        guard let accountEmail = UserDefaults.accessGroup.string(forKey: UserDefaultsKey.accountEmail) else {
            // TODO: - Add some custom error.
            result(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            return
        }

        Auth.auth().signIn(withEmail: accountEmail, link: link) { authResult, error in
            if let error = error {
                result(.failure(error))
                return
            }

            result(.success)
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

    func createUser(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }
}

extension NetworkGateway: LoginAccessing {
    func signIn(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error)
        }
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
                    // TODO: - Add custom error
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
    func getInstagramEmbedded(fromURL url: URL, result: @escaping ((Result<IGEmbedded, Error>) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let error = error { throw error }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.isSuccessCode else { throw URLError(.badServerResponse) }
                guard let data = data else { throw NSError(domain: "No data", code: 0, userInfo: nil) }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                let instagramEmbedded = try IGEmbedded(json: json)
                result(.success(instagramEmbedded))
            } catch {
                result(.failure(error))
            }
        }

        task.resume()
    }

    func getAccountsCount(result: @escaping ((Result<Int, Error>) -> Void)) {
        fireDB.collection("users").document(userID).collection("accounts")
            .getDocuments { snapshot, error in
                do {
                    if let error = error { throw error }
                    let accounts: [Account] = try snapshot!.documents.compactMap { snapshot -> Account in
                        let json = snapshot.data()
                        return try Account(json: json)
                    }

                    result(.success(accounts.count))
                } catch {
                    result(.failure(error))
                }
        }
    }
}

extension NetworkGateway: SettingsAccessing {
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

extension NetworkGateway: PostDetailAccessing {}
extension NetworkGateway: OnboardAccessing {}
