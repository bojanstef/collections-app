//
//  AccountsInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import CollectionsKit

protocol AccountsInteractable {
    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void))
    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void))
    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void))
    func scrapeAccounts(result: @escaping ((Result<Void, Error>) -> Void))
}

final class AccountsInteractor {
    fileprivate let networkAccess: AccountsAccessing

    init(networkAccess: AccountsAccessing) {
        self.networkAccess = networkAccess
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
}
