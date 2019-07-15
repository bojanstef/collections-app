//
//  AppCoordinator.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class AppCoordinator {
    fileprivate let navigationController = UINavigationController()
    fileprivate var activeCoordinator: Coordinating?

    init(window: UIWindow?) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

extension AppCoordinator: Coordinating {
    func start() {
        activeCoordinator = AuthCoordinator(navigationController: navigationController, delegate: self)
        activeCoordinator?.start()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didAuthenticate() {
        activeCoordinator = HomeCoordinator(navigationController: navigationController, delegate: self)
        activeCoordinator?.start()
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {}
