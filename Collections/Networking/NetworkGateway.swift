//
//  NetworkGateway.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDynamicLinks

final class NetworkGateway {
    private var userID: String? {
        return Auth.auth().currentUser?.uid
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

    func handleFirebaseUniversalLink(_ url: URL, completion: @escaping ((Result<URL, Error>) -> Void)) -> Bool {
        let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynanicLink, error in
            guard error == nil else { completion(.failure(error!)); return }
            guard let dynamicLinkURL = dynanicLink?.url else {
                // TODO: - Add some custom error.
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }

            completion(.success(dynamicLinkURL))
        }

        return linkHandled
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

extension NetworkGateway: PostsAccessing {
    func loadPosts(after date: Date, result: @escaping ((Result<[Post], Error>) -> Void)) {
        guard let userID = userID else {
            // TODO: - Add custom error.
            result(.failure(NSError(domain: "No User ID", code: 0, userInfo: nil)))
            return
        }

        let unixTimestamp = date.timeIntervalSince1970

        // TODO: - Add enum for Collection string values
        Firestore.firestore()
            .collection("users")
            .document(userID)
            .collection("posts")
            .whereField("timestamp", isGreaterThan: unixTimestamp)
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

extension NetworkGateway: AccountsAccessing {
    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void)) {
        guard let userID = userID else {
            // TODO: - Add custom error.
            result(.failure(NSError(domain: "No User ID", code: 0, userInfo: nil)))
            return
        }

        Firestore.firestore()
            .collection("users")
            .document(userID)
            .collection("accounts")
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

    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void)) {
        guard let userID = userID else {
            // TODO: - Add custom error OR create a better user management system.
            result(.failure(NSError(domain: "No User ID", code: 0, userInfo: nil)))
            return
        }

        Firestore.firestore()
            .collection("users")
            .document(userID)
            .collection("accounts")
            .addDocument(data: (account.json as? [String: Any])!) { error in
                guard let error = error else {
                    result(.success(account))
                    return
                }

                result(.failure(error))
            }
    }

    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void)) {
        guard let userID = userID else {
            // TODO: - Add custom error OR create a better user management system.
            result(.failure(NSError(domain: "No User ID", code: 0, userInfo: nil)))
            return
        }

        Firestore.firestore()
            .collection("users")
            .document(userID)
            .collection("accounts")
            .whereField("username", isEqualTo: account.username)
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
                    result(.success(()))
                }
            }
    }
}

extension NetworkGateway: SearchAccessing {}
