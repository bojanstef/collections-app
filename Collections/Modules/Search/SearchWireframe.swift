//
//  SearchWireframe.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol SearchModuleDelegate: AnyObject {}

final class SearchWireframe {
    fileprivate weak var moduleDelegate: SearchModuleDelegate?

    init(moduleDelegate: SearchModuleDelegate?) {
        self.moduleDelegate = moduleDelegate
    }
}

extension SearchWireframe {
    var viewController: UIViewController {
        let networkAccess: SearchAccessing = NetworkGateway()
        let interactor = SearchInteractor(networkAccess: networkAccess)
        let presenter = SearchPresenter(moduleDelegate: moduleDelegate, interactor: interactor)
        return UIStoryboard.instantiateInitialViewController(SearchViewController.self) { viewController in
            viewController.presenter = presenter
        }
    }
}
