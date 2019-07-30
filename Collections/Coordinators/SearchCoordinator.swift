//
//  SearchCoordinator.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-26.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class SearchCoordinator {
    let navigationController: TabBarNavigationController

    init() {
        self.navigationController = TabBarNavigationController(.search)
    }
}

extension SearchCoordinator: Coordinating {
    func start() {
        let viewController = SearchWireframe(moduleDelegate: self).viewController
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension SearchCoordinator: SearchModuleDelegate {
    func navigateToPostDetail(_ selectedPost: Post) {
        let viewController = PostDetailWireframe(moduleDelegate: self, selectedPost: selectedPost).viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SearchCoordinator: PostDetailModuleDelegate {}
