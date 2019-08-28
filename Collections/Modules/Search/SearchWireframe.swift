//
//  SearchWireframe.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol SearchModuleDelegate: AnyObject {
    func navigateToPostDetail(_ selectedPost: Post)
}

final class SearchWireframe {
    fileprivate weak var moduleDelegate: SearchModuleDelegate?

    init(moduleDelegate: SearchModuleDelegate?) {
        self.moduleDelegate = moduleDelegate
    }
}

extension SearchWireframe {
    var viewController: UIViewController {
        let interactor = SearchInteractor(facebookAccess: FacebookAccess.shared, photoAccess: PhotoAlbum.shared)
        let presenter = SearchPresenter(moduleDelegate: moduleDelegate, interactor: interactor)
        return UIStoryboard.instantiateInitialViewController(SearchViewController.self) { viewController in
            viewController.presenter = presenter
        }
    }
}
