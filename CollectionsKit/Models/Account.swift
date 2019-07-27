//
//  Account.swift
//  CollectionsKit
//
//  Created by Bojan Stefanovic on 2019-07-26.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

public struct Account: Modellable {
    public let username: String

    public init(username: String) {
        self.username = username
    }
}

extension Account: Comparable, Hashable {
    public static func < (lhs: Account, rhs: Account) -> Bool {
        return lhs.username < rhs.username
    }

    public static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.username == rhs.username
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(username)
    }
}
