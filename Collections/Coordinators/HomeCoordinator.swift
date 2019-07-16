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
    fileprivate weak var delegate: HomeCoordinatorDelegate?

    init(navigationController: UINavigationController, delegate: HomeCoordinatorDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
}

extension HomeCoordinator: Coordinating {
    func start() {
        let viewController = SearchWireframe(moduleDelegate: self).viewController
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension HomeCoordinator: SearchModuleDelegate {}
