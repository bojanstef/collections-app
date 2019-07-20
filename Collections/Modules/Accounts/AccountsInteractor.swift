//
//  AccountsInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AccountsInteractable {}

final class AccountsInteractor {
    fileprivate let networkAccess: AccountsAccessing

    init(networkAccess: AccountsAccessing) {
        self.networkAccess = networkAccess
    }
}

extension AccountsInteractor: AccountsInteractable {}
