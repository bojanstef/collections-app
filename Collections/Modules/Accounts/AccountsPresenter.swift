//
//  AccountsPresenter.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AccountsPresentable {
    var accountsMax: Int { get }
    var creditsCount: Int { get }
    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void))
    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void))
    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void))
    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void))
    func navigateToSettings()
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
    var accountsMax: Int {
        return interactor.accountsMax
    }

    var creditsCount: Int {
        return interactor.creditsCount
    }

    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void)) {
        interactor.loadAccounts(result: result)
    }

    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void)) {
        interactor.addAccount(account, result: result)
    }

    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void)) {
        interactor.deleteAccount(account, result: result)
    }

    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void)) {
        interactor.scrapeAccounts(result: result)
    }

    func navigateToSettings() {
        moduleDelegate?.navigateToSettings()
    }
}
