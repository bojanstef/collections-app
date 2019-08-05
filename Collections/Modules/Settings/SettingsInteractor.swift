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

    init(networkAccess: SettingsAccessing) {
        self.networkAccess = networkAccess
    }
}

extension SettingsInteractor: SettingsInteractable {
    func signOut() throws {
        try networkAccess.signOut()
    }
}
