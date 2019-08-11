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
