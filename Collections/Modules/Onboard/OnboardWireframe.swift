//
//  OnboardWireframe.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-02.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol OnboardModuleDelegate: AnyObject {
    func navigateToAuth()
}

final class OnboardWireframe {
    fileprivate weak var moduleDelegate: OnboardModuleDelegate?

    init(moduleDelegate: OnboardModuleDelegate?) {
        self.moduleDelegate = moduleDelegate
    }
}

extension OnboardWireframe {
    var viewController: UIViewController {
        let networkAccess: OnboardAccessing = NetworkGateway()
        let interactor = OnboardInteractor(networkAccess: networkAccess)
        let presenter = OnboardPresenter(moduleDelegate: moduleDelegate, interactor: interactor)
        return UIStoryboard.instantiateInitialViewController(OnboardViewController.self) { viewController in
            viewController.presenter = presenter
        }
    }
}
