//
//  LoginWireframe.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-16.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol LoginModuleDelegate: AnyObject {}

final class LoginWireframe {
    fileprivate weak var moduleDelegate: LoginModuleDelegate?

    init(moduleDelegate: LoginModuleDelegate?) {
        self.moduleDelegate = moduleDelegate
    }
}

extension LoginWireframe {
    var viewController: UIViewController {
        let networkAccess: LoginAccessing = NetworkGateway()
        let interactor = LoginInteractor(networkAccess: networkAccess)
        let presenter = LoginPresenter(moduleDelegate: moduleDelegate, interactor: interactor)
        return UIStoryboard.instantiateInitialViewController(LoginViewController.self) { viewController in
            viewController.presenter = presenter
        }
    }
}
