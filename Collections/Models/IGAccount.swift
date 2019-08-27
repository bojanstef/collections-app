//
//  IGAccount.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-25.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

enum IGTask: String, Modellable {
    case analyze = "ANALYZE"
    case advertise = "ADVERTISE"
    case moderate = "MODERATE"
    case createContent = "CREATE_CONTENT"
    case maange = "MANAGE"
}

struct IGCategory: Modellable {
    let id: String
    let name: String
}

struct IGAccount: Modellable {
    let accessToken: String
    let category: String
    let categoryList: [IGCategory]
    let name: String
    let id: String
    let tasks: [IGTask]
}
