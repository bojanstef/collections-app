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

        Auth.auth().signIn(withEmail: accountEmail, link: link) { result, error in
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

//extension NetworkGateway: SignupServiceable {
//    func checkIsUserLoggedIn(completion: @escaping ((Bool) -> Void)) {
//        completion(Auth.auth().currentUser != nil)
//    }
//}

//extension NetworkGateway: EmailAuthServiceable {}
//extension NetworkGateway: MyProfileServiceable {
//    func logout() {
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print()
//        }
//    }
//}
