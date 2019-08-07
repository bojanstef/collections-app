//
//  SettingsWireframe.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol SettingsModuleDelegate: AnyObject {}

final class SettingsWireframe {
    fileprivate weak var moduleDelegate: SettingsModuleDelegate?

    init(moduleDelegate: SettingsModuleDelegate?) {
        self.moduleDelegate = moduleDelegate
    }
}

extension SettingsWireframe {
    var viewController: UIViewController {
        let networkAccess: SettingsAccessing = NetworkGateway()
        let inAppStore = InAppStore()
        let interactor = SettingsInteractor(networkAccess: networkAccess, inAppStore: inAppStore)
        let presenter = SettingsPresenter(moduleDelegate: moduleDelegate, interactor: interactor)
        return UIStoryboard.instantiateInitialViewController(SettingsViewController.self) { viewController in
            viewController.presenter = presenter
        }
    }
}
