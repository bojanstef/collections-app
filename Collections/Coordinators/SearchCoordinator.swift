//
//  SearchCoordinator.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-26.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class SearchCoordinator {
    let navigationController: UINavigationController

    init() {
        self.navigationController = UINavigationController()
    }
}

extension SearchCoordinator: Coordinating {
    func start() {
        let viewController = SearchWireframe(moduleDelegate: self).viewController
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension SearchCoordinator: SearchModuleDelegate {
    func searchAfterDate(_ searchedDate: Date) {
        let viewController = PostsWireframe(moduleDelegate: self, searchedDate: searchedDate).viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SearchCoordinator: PostsModuleDelegate {
    func navigateToPostDetail(_ selectedPost: Post) {
        let viewController = PostDetailWireframe(moduleDelegate: self, selectedPost: selectedPost).viewController
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SearchCoordinator: PostDetailModuleDelegate {}
