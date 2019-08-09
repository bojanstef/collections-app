//
//  HTTPURLResponse+IsSuccessCode.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-08.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    /// According to [rfc2616](https://www.ietf.org/rfc/rfc2616.txt)
    /// the successful 2xx codes are 200..206
    /// while the 100 level codes are informational and the 300+ are redirects or errors
    var isSuccessCode: Bool {
        return 200..<300 ~= statusCode
    }
}
