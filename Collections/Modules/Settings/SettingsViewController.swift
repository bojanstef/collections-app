//
//  SettingsViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet fileprivate weak var toolbar: UIToolbar!
    var presenter: SettingsPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.tintColor = .black
    }
}

fileprivate extension SettingsViewController {
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try presenter.signOut()
        } catch {
            log.error(error)
        }
    }
}
