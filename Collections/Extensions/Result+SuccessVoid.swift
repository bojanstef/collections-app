//
//  Result+SuccessVoid.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-02.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import Foundation

extension Result where Success == Void {
    static var success: Result<Success, Failure> {
        return .success(())
    }
}
