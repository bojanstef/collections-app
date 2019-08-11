//
//  KeychainStorage.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-10.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation
import KeychainAccess

enum KeychainKey: String {
    case creditsCount
    case accountsMax
}

protocol KeychainAccessing {
    func save(_ credits: Credit, result: @escaping ((Result<Void, Error>) -> Void))
    func getCreditsCount(result: ((Result<Int, Error>) -> Void))
    func save(_ maxAccounts: MaxAccount, result: @escaping ((Result<Void, Error>) -> Void))
    func getAccountsMax(result: ((Result<Int, Error>) -> Void))
}

final class KeychainStorage {
    fileprivate let store: Keychain

    init(_ identifier: String = "xyz.bojan.Collections.default") {
        self.store = Keychain(service: identifier)
    }

    func getInt(_ key: KeychainKey) throws -> Int? {
        guard let strValue = try store.getString(key.rawValue) else {
            return nil
        }

        return Int(strValue)
    }

    func set(_ value: Int, forKey key: KeychainKey) throws {
        try store.set(String(value), key: key.rawValue)
    }
}

extension KeychainStorage: KeychainAccessing {
    func save(_ credits: Credit, result: @escaping ((Result<Void, Error>) -> Void)) {
        do {
            if let creditsCount = try getInt(.creditsCount) {
                try set(creditsCount + credits.creditType.intValue, forKey: .creditsCount)
            } else {
                try set(credits.creditType.intValue, forKey: .creditsCount)
            }
        } catch {
            result(.failure(error))
        }
    }

    func getCreditsCount(result: ((Result<Int, Error>) -> Void)) {
        do {
            let creditsCount = try getInt(.creditsCount) ?? 0
            result(.success(creditsCount))
        } catch {
            result(.failure(error))
        }
    }

    func save(_ maxAccounts: MaxAccount, result: @escaping ((Result<Void, Error>) -> Void)) {
        do {
            try set(maxAccounts.maxAccountType.intValue, forKey: .accountsMax)
        } catch {
            result(.failure(error))
        }
    }

    func getAccountsMax(result: ((Result<Int, Error>) -> Void)) {
        do {
            let accountsMax = try getInt(.accountsMax) ?? 5
            result(.success(accountsMax))
        } catch {
            result(.failure(error))
        }
    }
}
