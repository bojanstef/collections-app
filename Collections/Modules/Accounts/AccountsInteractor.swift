//
//  AccountsInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AccountsInteractable {
    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void))
    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void))
    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void))
    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void))
    func getCreditsCount(result: ((Result<Int, Error>) -> Void))
    func getAccountsMax(result: ((Result<Int, Error>) -> Void))
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
        networkAccess.scrapeAccounts(result: result)
    }

    func getCreditsCount(result: ((Result<Int, Error>) -> Void)) {
        keychainStorage.getCreditsCount(result: result)
    }

    func getAccountsMax(result: ((Result<Int, Error>) -> Void)) {
        keychainStorage.getAccountsMax(result: result)
    }
}
