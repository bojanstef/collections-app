//
//  Account.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-10.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

struct Account: Modellable {
    let username: String

    init(username: String) {
        self.username = username
    }
}

extension Account: Comparable, Hashable {
    static func < (lhs: Account, rhs: Account) -> Bool {
        return lhs.username < rhs.username
    }

    static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.username == rhs.username
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(username)
    }
}
