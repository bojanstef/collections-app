//
//  SettingsAccessing.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol SettingsAccessing {
    func upload(credits: Credit, result: @escaping ((Result<Void, Error>) -> Void))
    func signOut() throws
}
