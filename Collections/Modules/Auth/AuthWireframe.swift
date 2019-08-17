//
//  AuthWireframe.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol AuthModuleDelegate: AnyObject {
    func navigateToLogin()
}

final class AuthWireframe {
    fileprivate weak var moduleDelegate: AuthModuleDelegate?

    init(moduleDelegate: AuthModuleDelegate?) {
        self.moduleDelegate = moduleDelegate
    }
}

extension AuthWireframe {
    var viewController: UIViewController {
        let networkAccess: AuthAccessing = NetworkGateway()
        let interactor = AuthInteractor(networkAccess: networkAccess)
        let presenter = AuthPresenter(moduleDelegate: moduleDelegate, interactor: interactor)
        return UIStoryboard.instantiateInitialViewController(AuthViewController.self) { viewController in
            viewController.presenter = presenter
        }
    }
}
