//
//  AppDelegate.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
final class AppDelegate: UIResponder {
    fileprivate var authStateChangeHandler: AuthStateDidChangeListenerHandle?
    fileprivate lazy var appCoordinator = AppCoordinator(window: window!)
    fileprivate lazy var deepLinkHandler = DeepLinkHandler()
    fileprivate lazy var networkGateway: AppDelegateAccessing = NetworkGateway()
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    deinit {
        authStateChangeHandler.flatMap(Auth.auth().removeStateDidChangeListener)
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        authStateChangeHandler = Auth.auth().addStateDidChangeListener { auth, user in
            self.handleAuthStateChange(auth: auth, user: user)
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        log.debug("I have received a URL through a custom scheme \(url.absoluteString)")

        if deepLinkHandler.isFirebaseDynamicLink(fromCustomSchemeURL: url) {
            handleDeepLink(url)
            return true
        } else {
            // Maybe handle Google or Facebook sign-in here
            return false
        }
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let incomingURL = userActivity.webpageURL else {
            log.debug("User activity does not contain a webpageURL \(userActivity)")
            return false
        }

        log.debug("Incoming URL is \(incomingURL)")
        let isFirebaseLinkHandled = deepLinkHandler.handleFirebaseUniversalLink(incomingURL) { result in
            switch result {
            case .success(let url):
                self.handleDeepLink(url)
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
    func handleDeepLink(_ url: URL) {
        if deepLinkHandler.isFirebaseSignInLink(url.absoluteString) {
            networkGateway.signIn(withEmailSignupLink: url.absoluteString) { result in
                switch result {
                case .success:
                    log.info("User logged in, navigating to home.")
                case .failure(let error):
                    log.error(error.localizedDescription)
                }
            }
        } else {
            log.debug("Not a sign-in deep link: \(url)")
        }
    }

    func handleAuthStateChange(auth: Auth, user: User?) {
        if let currentUser = auth.currentUser, let user = user, currentUser.uid == user.uid {
            if let sharedContainer = UserDefaults(suiteName: AccessGroup.default) {
                sharedContainer.set(currentUser.uid, forKey: UserDefaultsKey.userID)
            }

            appCoordinator.didAuthenticate()
        } else {
            appCoordinator.start()
        }
    }
}
