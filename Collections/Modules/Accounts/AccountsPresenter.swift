//
//  AccountsPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import CollectionsKit

protocol AccountsPresentable {
    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void))
    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void))
    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void))
}

final class AccountsPresenter {
    fileprivate weak var moduleDelegate: AccountsModuleDelegate?
    fileprivate let interactor: AccountsInteractable

    init(moduleDelegate: AccountsModuleDelegate?, interactor: AccountsInteractable) {
        self.moduleDelegate = moduleDelegate
        self.interactor = interactor
    }
}

extension AccountsPresenter: AccountsPresentable {
    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void)) {
        interactor.loadAccounts(result: result)
    }

    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void)) {
        interactor.addAccount(account, result: result)
    }

    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void)) {
        interactor.deleteAccount(account, result: result)
    }
}
