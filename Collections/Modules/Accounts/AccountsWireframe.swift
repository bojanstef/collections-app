//
//  AccountsWireframe.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol AccountsModuleDelegate: AnyObject {}

final class AccountsWireframe {
    fileprivate weak var moduleDelegate: AccountsModuleDelegate?

    init(moduleDelegate: AccountsModuleDelegate?) {
        self.moduleDelegate = moduleDelegate
    }
}

extension AccountsWireframe {
    var viewController: UIViewController {
        let networkAccess: AccountsAccessing = NetworkGateway()
        let interactor = AccountsInteractor(networkAccess: networkAccess)
        let presenter = AccountsPresenter(moduleDelegate: moduleDelegate, interactor: interactor)
        return UIStoryboard.instantiateInitialViewController(AccountsViewController.self) { viewController in
            viewController.presenter = presenter
        }
    }
}
