//
//  PostDetailWireframe.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-22.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol PostDetailModuleDelegate: AnyObject {}

final class PostDetailWireframe {
    fileprivate weak var moduleDelegate: PostDetailModuleDelegate?
    fileprivate let selectedPost: Post

    init(moduleDelegate: PostDetailModuleDelegate?, selectedPost: Post) {
        self.moduleDelegate = moduleDelegate
        self.selectedPost = selectedPost
    }
}

extension PostDetailWireframe {
    var viewController: UIViewController {
        let networkAccess: PostDetailAccessing = NetworkGateway()
        let interactor = PostDetailInteractor(networkAccess: networkAccess, selectedPost: selectedPost)
        let presenter = PostDetailPresenter(moduleDelegate: moduleDelegate, interactor: interactor)
        return UIStoryboard.instantiateInitialViewController(PostDetailViewController.self) { viewController in
            viewController.presenter = presenter
        }
    }
}
