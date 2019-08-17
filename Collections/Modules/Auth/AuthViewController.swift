//
//  AuthViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

private enum Constants {
    static let animationDuration: TimeInterval = 0.6
}

final class AuthViewController: UIViewController {
    fileprivate enum AuthType {
        case emailPassword
        case passwordless

        var toggleButtonTitle: String {
            switch self {
            case .emailPassword:    return "Sign in with password"
            case .passwordless:     return "Sign in passwordless"
            }
        }

        func toggle() -> AuthType {
            switch self {
            case .emailPassword:    return .passwordless
            case .passwordless:     return .emailPassword
            }
        }
    }

    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var continueWithEmailButton: ActionButton!
    @IBOutlet fileprivate weak var signInTypeButton: UIButton!
    @IBOutlet fileprivate weak var toolbar: Toolbar!
    @IBOutlet fileprivate weak var loginBarButtonItem: UIBarButtonItem!
    fileprivate var authType: AuthType = .emailPassword
    var presenter: AuthPresentable!

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

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            switch authType {
            case .emailPassword:
                passwordTextField.becomeFirstResponder()
            case .passwordless:
                continueWithEmailButtonPressed(self)
            }
        case passwordTextField:
            switch authType {
            case .emailPassword:
                continueWithEmailButtonPressed(self)
            case .passwordless:
                return true
            }
        default:
            return true
        }

        return false
    }
}

fileprivate extension AuthViewController {
    @IBAction func signInTypeButtonPressed(_ sender: Any) {
        // isPasswordless means we're switching to email/password.
        let isPasswordless = authType == .passwordless

        // Since we're transitioning to emailPassword, emailTextField.returnKeyType should be .next.
        emailTextField.returnKeyType = isPasswordless ? .next : .done

        // During a toggle set the email as selected after setting its returnKeyType.
        emailTextField.resignFirstResponder()
        emailTextField.becomeFirstResponder()

        // Sign in button should say "Switch to passwordless".
        signInTypeButton.setTitle(authType.toggleButtonTitle, for: .normal)

        // Only set the textField visible if it was previously hidden.
        if isPasswordless {
            passwordTextField.isHidden = false
        }

        // Since we're transitioning to emailPassword, we should show the textField.
        UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
            self?.passwordTextField.alpha = isPasswordless ? 1 : 0
        }, completion: { [weak self] _ in
            self?.passwordTextField.isHidden = !isPasswordless
        })

        // Now we toggle auth type so that it's ".emailPassword".
        authType = authType.toggle()
    }

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

        switch authType {
        case .emailPassword:
            guard let passwordText = passwordTextField.text else {
                showErrorAlert(AuthError.emptyPassword)
                return
            }
            presenter.createUser(withEmail: cleanedEmail, password: passwordText) { [weak self] error in
                self?.handleSignin(email: cleanedEmail, error: error)
            }

        case .passwordless:
            presenter.signIn(withEmail: cleanedEmail) { [weak self] error in
                self?.handleSignin(email: cleanedEmail, error: error)
            }
        }
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        presenter.navigateToLogin()
    }

    func handleSignin(email: String, error: Error?) {
        if let error = error {
            passwordTextField.text = nil
            showErrorAlert(error)
            return
        }

        UserDefaults.accessGroup.set(email, forKey: UserDefaultsKey.accountEmail)
        if authType == .passwordless {
            showPasswordlessAuthAlert()
        }
    }

    func showPasswordlessAuthAlert() {
        DispatchQueue.main.async { [weak self] in
            let title = "Success"
            let message = "Check your email to finish your sign in"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
