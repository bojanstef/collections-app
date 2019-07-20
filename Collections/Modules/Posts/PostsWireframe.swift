//
//  PostsWireframe.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol PostsModuleDelegate: AnyObject {}

final class PostsWireframe {
    fileprivate weak var moduleDelegate: PostsModuleDelegate?
    fileprivate let searchedDate: Date

    init(moduleDelegate: PostsModuleDelegate?, searchedDate: Date) {
        self.moduleDelegate = moduleDelegate
        self.searchedDate = searchedDate
    }
}

extension PostsWireframe {
    var viewController: UIViewController {
        let networkAccess: PostsAccessing = NetworkGateway()
        let interactor = PostsInteractor(networkAccess: networkAccess, searchedDate: searchedDate)
        let presenter = PostsPresenter(moduleDelegate: moduleDelegate, interactor: interactor)
        return UIStoryboard.instantiateInitialViewController(PostsViewController.self) { viewController in
            viewController.presenter = presenter
        }
    }
}
