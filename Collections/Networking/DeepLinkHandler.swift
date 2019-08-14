//
//  DeepLinkHandler.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-14.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDynamicLinks

final class DeepLinkHandler {
    fileprivate let dynamicLinks: DynamicLinks

    init() {
        // Returns nil on iOS versions prior to 8 and we only support 12.0+
        dynamicLinks = DynamicLinks.dynamicLinks()!
    }

    func isFirebaseDynamicLink(fromCustomSchemeURL url: URL) -> Bool {
        guard let dynamicLink = dynamicLinks.dynamicLink(fromCustomSchemeURL: url) else {
            log.debug("Dynamic link could not be instantiated from url: \(url)")
            return false
        }

        guard let dynamicLinkURL = dynamicLink.url else {
            log.debug("Dynamic link object has no url, \(dynamicLink)")
            return false
        }

        log.debug(dynamicLinkURL)
        return true
    }

    func isFirebaseSignInLink(_ emailLink: String) -> Bool {
        return Auth.auth().isSignIn(withEmailLink: emailLink)
    }

    func handleFirebaseUniversalLink(_ url: URL, completion: @escaping ((Result<URL, Error>) -> Void)) -> Bool {
        let linkHandled = dynamicLinks.handleUniversalLink(url) { dynanicLink, error in
            do {
                if let error = error { throw error }
                guard let dynamicLinkURL = dynanicLink?.url else { throw URLError(.badURL) }
                completion(.success(dynamicLinkURL))
            } catch {
                completion(.failure(error))
            }
        }

        return linkHandled
    }
}
