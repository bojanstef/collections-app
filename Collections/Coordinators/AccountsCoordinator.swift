//
//  AccountsCoordinator.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-26.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class AccountsCoordinator {
    let navigationController: TabBarNavigationController

    init() {
        self.navigationController = TabBarNavigationController(.accounts)
    }
}

extension AccountsCoordinator: Coordinating {
    func start() {
        let viewController = AccountsWireframe(moduleDelegate: self).viewController
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension AccountsCoordinator: AccountsModuleDelegate {}
