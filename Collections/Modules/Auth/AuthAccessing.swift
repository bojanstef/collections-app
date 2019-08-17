//
//  AuthAccessing.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol AuthAccessing {
    func signIn(withEmail email: String, completion: @escaping ((Error?) -> Void))
    func createUser(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void))
}
