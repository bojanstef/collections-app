//
//  ErrorAlertController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-14.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class ErrorAlertFactory {
    private init() {}

    static func getAlert(_ error: Error, okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        return getAlertHelper(error.localizedDescription, okHandler: okHandler)
    }

    static func getAlert(_ message: String, okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        return getAlertHelper(message, okHandler: okHandler)
    }
}

fileprivate extension ErrorAlertFactory {
    static func getAlertHelper(_ message: String, okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let errorAlert = UIAlertController(title: "Whoops 😱", message: message, preferredStyle: .alert)
        errorAlert.addAction(.init(title: "Ok", style: .default, handler: okHandler))
        return errorAlert
    }
}
