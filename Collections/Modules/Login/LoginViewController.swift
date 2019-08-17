//
//  LoginViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-16.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var toolbar: Toolbar!
    var presenter: LoginPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            continueWithEmailButtonPressed(self)
        default:
            return true
        }

        return false
    }
}

fileprivate extension LoginViewController {
    @IBAction func continueWithEmailButtonPressed(_ sender: Any) {
        guard let emailText = emailTextField.text else {
            showErrorAlert(AuthError.invalidEmail)
            return
        }

        let cleanedEmail = emailText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleanedEmail.isValidEmail else {
            showErrorAlert(AuthError.invalidEmail)
            return
        }

        guard let passwordText = passwordTextField.text else {
            showErrorAlert(AuthError.emptyPassword)
            return
        }

        presenter.signIn(withEmail: cleanedEmail, password: passwordText) { [weak self] error in
            self?.handleSignin(email: cleanedEmail, error: error)
        }
    }

    @IBAction func createAccountBarButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func handleSignin(email: String, error: Error?) {
        if let error = error {
            passwordTextField.text = nil
            showErrorAlert(error)
            return
        }

        UserDefaults.accessGroup.set(email, forKey: UserDefaultsKey.accountEmail)
    }
}
