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
    var creditsCount: Int { get }
    func save(_ credits: Credit, result: @escaping ((Result<Void, Error>) -> Void))
    func updateCredits(_ count: Int) throws

    var accountsMax: Int { get }
    func save(_ maxAccounts: MaxAccount, result: @escaping ((Result<Void, Error>) -> Void))
}

final class KeychainStorage {
    fileprivate let store: Keychain

    init(_ userID: String) {
        self.store = Keychain(service: userID)
    }

    fileprivate func getInt(_ key: KeychainKey) throws -> Int? {
        guard let strValue = try store.getString(key.rawValue) else {
            return nil
        }

        return Int(strValue)
    }

    fileprivate func set(_ value: Int, forKey key: KeychainKey) throws {
        try store.set(String(value), key: key.rawValue)
    }
}

extension KeychainStorage: KeychainAccessing {
    var creditsCount: Int {
        do {
            let creditsCountValue = try getInt(.creditsCount)
            return creditsCountValue ?? 0
        } catch {
            log.error(error.localizedDescription)
            return 0
        }
    }

    func save(_ credits: Credit, result: @escaping ((Result<Void, Error>) -> Void)) {
        do {
            if let creditsCount = try getInt(.creditsCount) {
                try set(creditsCount + credits.creditType.intValue, forKey: .creditsCount)
            } else {
                try set(credits.creditType.intValue, forKey: .creditsCount)
            }
            result(.success)
        } catch {
            result(.failure(error))
        }
    }

    func updateCredits(_ count: Int) throws {
        try set(count, forKey: .creditsCount)
    }

    var accountsMax: Int {
        do {
            let accountsMaxValue = try getInt(.accountsMax)
            return accountsMaxValue ?? 5
        } catch {
            log.error(error.localizedDescription)
            return 5
        }
    }

    func save(_ maxAccounts: MaxAccount, result: @escaping ((Result<Void, Error>) -> Void)) {
        do {
            try set(maxAccounts.maxAccountType.intValue, forKey: .accountsMax)
            result(.success)
        } catch {
            result(.failure(error))
        }
    }
}
