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
    func connectToInstagram(result: @escaping ((Result<Void, Error>) -> Void))
    func getBusinessAccounts(result: @escaping ((Result<Void, Error>) -> Void))
    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void))
    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void))
    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void))
}

final class AccountsInteractor {
    fileprivate let networkAccess: AccountsAccessing
    fileprivate let keychainStorage: KeychainAccessing
    fileprivate let facebookAccess: FacebookAccessing

    init(networkAccess: AccountsAccessing, keychainStorage: KeychainAccessing, facebookAccess: FacebookAccessing) {
        self.networkAccess = networkAccess
        self.keychainStorage = keychainStorage
        self.facebookAccess = facebookAccess
    }
}

extension AccountsInteractor: AccountsInteractable {
    var accountsMax: Int {
        return keychainStorage.accountsMax
    }

    func connectToInstagram(result: @escaping ((Result<Void, Error>) -> Void)) {
        facebookAccess.connectToInstagram(result: result)
    }

    func getBusinessAccounts(result: @escaping ((Result<Void, Error>) -> Void)) {
        facebookAccess.getBusinessAccounts(result: result)
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
}
