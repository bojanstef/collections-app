//
//  SettingsAccessing.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SettingsAccessing {
    var userID: String { get }
    func signOut() throws
}
