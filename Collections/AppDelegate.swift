//
//  AppDelegate.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

let log = Logger()

@UIApplicationMain
final class AppDelegate: UIResponder {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    fileprivate lazy var appCoordinator = AppCoordinator(window: window)
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appCoordinator.start()
        return true
    }
}
