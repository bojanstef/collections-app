//
//  HomeCoordinator.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {}

final class HomeCoordinator {
    fileprivate let navigationController: UINavigationController
    fileprivate let tabBarController = MainTabBarController()
    fileprivate let searchCoordinator = SearchCoordinator()
    fileprivate let accountsCoordinator = AccountsCoordinator()
    fileprivate weak var delegate: HomeCoordinatorDelegate?

    init(navigationController: UINavigationController, delegate: HomeCoordinatorDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
}

extension HomeCoordinator: Coordinating {
    func start() {
        searchCoordinator.start()
        accountsCoordinator.start()

        let viewControllers = [searchCoordinator.navigationController, accountsCoordinator.navigationController]
        tabBarController.loadControllers(viewControllers, animated: false)
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
    }
}
