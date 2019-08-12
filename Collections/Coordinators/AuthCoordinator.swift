//
//  AuthCoordinator.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func didAuthenticate()
}

final class AuthCoordinator {
    fileprivate let navigationController: UINavigationController
    fileprivate weak var delegate: AuthCoordinatorDelegate?

    init(navigationController: UINavigationController, delegate: AuthCoordinatorDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
}

extension AuthCoordinator: Coordinating {
    func start() {
        let viewController = OnboardWireframe(moduleDelegate: self).viewController
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension AuthCoordinator: OnboardModuleDelegate {
    func navigateToAuth() {
        let viewController = AuthWireframe(moduleDelegate: self).viewController
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension AuthCoordinator: AuthModuleDelegate {}
