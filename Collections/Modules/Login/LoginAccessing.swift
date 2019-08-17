//
//  LoginAccessing.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-16.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

protocol LoginAccessing {
    func signIn(withEmail email: String, password: String, completion: @escaping ((Error?) -> Void))
}
