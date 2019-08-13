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
    @IBOutlet fileprivate weak var continueWithEmailButton: ActionButton!
    var presenter: AuthPresentable!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

fileprivate extension AuthViewController {
    @IBAction func continueWithEmailButtonPressed(_ sender: Any) {
        guard let emailText = emailTextField.text else {
            showAlert(EmailError.invalid)
            return
        }

        let cleanedEmail = emailText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleanedEmail.isValidEmail else {
            showAlert(EmailError.invalid)
            return
        }

        presenter.signIn(withEmail: cleanedEmail) { [weak self] error in
            guard let error = error else {
                UserDefaults.standard.set(cleanedEmail, forKey: UserDefaultsKey.accountEmail)
                self?.showAlert()
                return
            }

            self?.showAlert(error)
        }
    }

    func showAlert(_ error: Error? = nil) {
        let title = error == nil ? "Success" : "Error"
        let message = error == nil ? "Check your email to finish your sign in" : error?.localizedDescription
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
