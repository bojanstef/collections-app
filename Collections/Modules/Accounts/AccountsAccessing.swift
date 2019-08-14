//
//  AccountsAccessing.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AccountsAccessing {
    var userID: String { get }
    func addAccount(_ account: Account, result: @escaping ((Result<Account, Error>) -> Void))
    func loadAccounts(result: @escaping ((Result<[Account], Error>) -> Void))
    func deleteAccount(_ account: Account, result: @escaping ((Result<Void, Error>) -> Void))
    func scrapeAccounts(updateCreditsBlock: @escaping (() throws -> Void), result: @escaping ((Result<Void, Error>) -> Void))
}
