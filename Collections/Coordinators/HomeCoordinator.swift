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

extension HomeCoordinator: SearchModuleDelegate {
    func searchAfterDate(_ searchedDate: Date) {
        let viewController = PostsWireframe(moduleDelegate: self, searchedDate: searchedDate).viewController
        navigationController.pushViewController(viewController, animated: true)
    }

    func navigateToAccounts() {
        let viewController = AccountsWireframe(moduleDelegate: self).viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: PostsModuleDelegate {
    func navigateToPostDetail(_ selectedPost: Post) {
        let viewController = PostDetailWireframe(moduleDelegate: self, selectedPost: selectedPost).viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: AccountsModuleDelegate {}
extension HomeCoordinator: PostDetailModuleDelegate {}
