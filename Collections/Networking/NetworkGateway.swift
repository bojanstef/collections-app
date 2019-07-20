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

final class NetworkGateway {}

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
        guard let userID = Auth.auth().currentUser?.uid else {
            // TODO: - Add custom error.
            result(.failure(NSError(domain: "No User ID", code: 0, userInfo: nil)))
            return
        }

        let unixTimestamp = date.timeIntervalSince1970

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

extension NetworkGateway: SearchAccessing {}
extension NetworkGateway: AccountsAccessing {}
