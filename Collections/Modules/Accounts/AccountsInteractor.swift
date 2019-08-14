//
//  AccountsInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AccountsInteractable {
    var accountsMax: Int { get }
    var creditsCount: Int { get }
    func giveNewUserFreeCredits()
    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void))
    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void))
    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void))
    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void))
}

final class AccountsInteractor {
    fileprivate let networkAccess: AccountsAccessing
    fileprivate let keychainStorage: KeychainAccessing

    init(networkAccess: AccountsAccessing, keychainStorage: KeychainAccessing) {
        self.networkAccess = networkAccess
        self.keychainStorage = keychainStorage
    }
}

extension AccountsInteractor: AccountsInteractable {
    var accountsMax: Int {
        return keychainStorage.accountsMax
    }

    var creditsCount: Int {
        return keychainStorage.creditsCount
    }

    func giveNewUserFreeCredits() {
        keychainStorage.giveNewUserFreeCredits()
    }

    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void)) {
        networkAccess.loadAccounts(result: result)
    }

    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void)) {
        networkAccess.addAccount(account, result: result)
    }

    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void)) {
        networkAccess.deleteAccount(account, result: result)
    }

    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void)) {
        networkAccess.scrapeAccounts(
            updateCreditsBlock: { [weak self] in
                guard let this = self else { throw ReferenceError.type(self) }
                guard this.keychainStorage.creditsCount > 0 else { throw CreditError.notEnough }
                try this.keychainStorage.updateCredits(this.keychainStorage.creditsCount - 1)
            }, validateAccountsBlock: { [weak self] accountsCount in
                guard let this = self else { throw ReferenceError.type(self) }
                guard accountsCount <= this.keychainStorage.accountsMax else { throw AccountError.maximumReached }
        }, result: result)
    }
}
