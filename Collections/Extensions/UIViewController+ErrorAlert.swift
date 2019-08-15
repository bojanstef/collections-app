//
//  UIViewController+ErrorAlert.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-14.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorAlert(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            let errorAlert = ErrorAlertFactory.getAlert(error)
            self?.present(errorAlert, animated: true)
        }
    }
}
