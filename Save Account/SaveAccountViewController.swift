//
//  SaveAccountViewController.swift
//  Save Account
//
//  Created by Bojan Stefanovic on 2019-07-25.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase

final class SaveAccountViewController: UIViewController {
    @IBOutlet fileprivate weak var usernameLabel: UILabel!
    fileprivate let networkGateway: SaveAccountAccessing = NetworkGateway()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: .cancelPressed)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: .savePressed)
        FirebaseApp.configure()
        loadInstagramAccountName()
    }
}

fileprivate extension SaveAccountViewController {
    @objc func dismissAlertExtension() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        let returningItems = extensionContext?.inputItems
        extensionContext?.completeRequest(returningItems: returningItems)
    }

    @objc func savePressed() {
        guard let username = usernameLabel.text else { print("No username"); return }
        let account = Account(username: username)
        networkGateway.addAccount(account) { [weak self] result in
            switch result {
            case .success(let accountSaved):
                self?.showSuccessAlert(accountSaved)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func loadInstagramAccountName() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else { print("No extension item"); return }
        guard let provider = extensionItem.attachments?.first else { print("No provider"); return }
        provider.loadItem(forTypeIdentifier: String(kUTTypeURL)) { [weak self] coding, error in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let photoURL = coding as? URL else { print("Could not get URL"); return }
            let igEmbedUrlString = "https://api.instagram.com/oembed/?url=\(photoURL.absoluteString)"
            guard let igEmbedURL = URL(string: igEmbedUrlString) else { print("Could not init IG Embed URL"); return }
            self?.getInstagramEmbedded(fromURL: igEmbedURL)
        }
    }

    func getInstagramEmbedded(fromURL url: URL) {
        networkGateway.getInstagramEmbedded(fromURL: url) { [weak self] result in
            switch result {
            case .success(let instagramEmbedded):
                DispatchQueue.main.async { [weak self] in
                    self?.usernameLabel.text = instagramEmbedded.authorName
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func showSuccessAlert(_ accountSaved: Account) {
        let alert = UIAlertController(title: "Success", message: "Saved account @\(accountSaved.username)", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            self?.dismissAlertExtension()
        })

        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
}

fileprivate extension Selector {
    static let cancelPressed = #selector(SaveAccountViewController.dismissAlertExtension)
    static let savePressed = #selector(SaveAccountViewController.savePressed)
}
