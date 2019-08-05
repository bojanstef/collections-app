//
//  SettingsPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SettingsPresentable {
    func signOut() throws
}

final class SettingsPresenter {
    fileprivate weak var moduleDelegate: SettingsModuleDelegate?
    fileprivate let interactor: SettingsInteractable

    init(moduleDelegate: SettingsModuleDelegate?, interactor: SettingsInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension SettingsPresenter: SettingsPresentable {
    func signOut() throws {
        try interactor.signOut()
    }
}
