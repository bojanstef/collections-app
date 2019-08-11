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
    func isFirebaseDynamicLink(fromCustomSchemeURL url: URL) -> Bool {
        guard let dynamicLinks = DynamicLinks.dynamicLinks() else {
            log.debug("Dynamic links could not be instantiated")
            return false
        }

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
}
