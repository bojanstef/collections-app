//
//  URL+StringThrow.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-25.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

extension URL {
    init(_ string: String) throws {
        guard let url = URL(string: string) else { throw URLError(.badURL) }
        self = url
    }
}
