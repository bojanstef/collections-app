//
//  AppDelegate.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import Firebase

let log = Logger()

@UIApplicationMain
final class AppDelegate: UIResponder {
    fileprivate lazy var appCoordinator = AppCoordinator(window: window)
    fileprivate lazy var deepLinkHandler = DeepLinkHandler()
    fileprivate lazy var networkGateway: AppDelegateAccessing = NetworkGateway()
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
}

extension AppDelegate: UIApplicationDelegate {
    // swiftlint:disable:next line_length
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        appCoordinator.start()
        return true
    }

    // swiftlint:disable:next line_length
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        log.debug("I have received a URL through a custom scheme \(url.absoluteString)")

        if deepLinkHandler.isFirebaseDynamicLink(fromCustomSchemeURL: url) {
            if deepLinkHandler.isFirebaseSignInLink(url.absoluteString) {
                handleSignInDeepLink(url)
            } else {
                log.debug("Not a sign in deep link")
            }

            return true
        } else {
            // Maybe handle Google or Facebook sign-in here
            return false
        }
    }

    // swiftlint:disable:next line_length
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let incomingURL = userActivity.webpageURL else {
            log.debug("User activity does not contain a webpageURL \(userActivity)")
            return false
        }

        log.debug("Incoming URL is \(incomingURL)")
        let isFirebaseLinkHandled = networkGateway.handleFirebaseUniversalLink(incomingURL) { result in
            switch result {
            case .success(let url):
                if self.deepLinkHandler.isFirebaseSignInLink(url.absoluteString) {
                    self.handleSignInDeepLink(url)
                } else {
                    log.debug("Not a sign in deep link")
                }
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }

        if isFirebaseLinkHandled {
            return true
        } else {
            // Maybe do other things with our incoming URL?
            return false
        }
    }
}

fileprivate extension AppDelegate {
    func handleSignInDeepLink(_ url: URL) {
        networkGateway.signIn(withEmailSignupLink: url.absoluteString) { result in
            switch result {
            case .success:
                self.appCoordinator.didAuthenticate()
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }
}
