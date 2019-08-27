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
    case accountsMax
}

protocol KeychainAccessing {
    var accountsMax: Int { get }
    func save(_ maxAccounts: MaxAccount, result: @escaping ((Result<Void, Error>) -> Void))
}

final class KeychainStorage {
    fileprivate let store: Keychain

    init(_ userID: String) {
        self.store = Keychain(service: userID, accessGroup: AccessGroup.default.rawValue)
    }
}

fileprivate extension KeychainStorage {
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
