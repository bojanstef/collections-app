//
//  DataContainer.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-25.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

struct Cursors: Modellable {
    let after: String?
    let before: String?
}

struct Paging: Modellable {
    let cursors: Cursors
}

struct DataContainer<T: Modellable>: Modellable {
    let data: [T]
    let paging: Paging
}
