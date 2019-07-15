//
//  AuthViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class AuthViewController: UIViewController {
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var continueWithEmailButton: UIButton!
    var presenter: AuthPresentable!
}

fileprivate extension AuthViewController {
    @IBAction func continueWithEmailButtonPressed(_ sender: Any) {
        guard let emailText = emailTextField.text else {
            log.info("Validate email text field contains an email.")
            return
        }

        // TODO: - Add proper validation for the email.
        presenter.signIn(withEmail: emailText) { error in
            guard error == nil else { log.error(error!.localizedDescription); return }
            UserDefaults.standard.set(emailText, forKey: UserDefaultsKey.accountEmail)
            // TODO: - Create UI / UX to prompt the user to check their email.
            log.info("Check your email.")
        }
    }
}
