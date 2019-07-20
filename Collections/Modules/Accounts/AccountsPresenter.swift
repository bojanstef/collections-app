//
//  AccountsPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AccountsPresentable {}

final class AccountsPresenter {
    fileprivate weak var moduleDelegate: AccountsModuleDelegate?
    fileprivate let interactor: AccountsInteractable

    init(moduleDelegate: AccountsModuleDelegate?, interactor: AccountsInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension AccountsPresenter: AccountsPresentable {}
