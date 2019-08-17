//
//  UserDefaults+AccessGroup.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-16.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

extension UserDefaults {
    static var accessGroup: UserDefaults {
        return self.init(suiteName: AccessGroup.default.rawValue)!
    }
}
