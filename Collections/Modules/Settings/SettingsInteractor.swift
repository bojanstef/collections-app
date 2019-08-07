//
//  SettingsInteractor.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SettingsInteractable {
    func signOut() throws
}

final class SettingsInteractor {
    fileprivate let networkAccess: SettingsAccessing
    fileprivate let inAppStore: InAppStore

    init(networkAccess: SettingsAccessing, inAppStore: InAppStore) {
        self.networkAccess = networkAccess
        self.inAppStore = inAppStore
    }
}

extension SettingsInteractor: SettingsInteractable {
    func signOut() throws {
        try networkAccess.signOut()
    }
}
