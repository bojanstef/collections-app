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

private let log = Logger(category: "Action Extension")

final class SaveAccountViewController: UIViewController {
    fileprivate let networkGateway: SaveAccountAccessing = NetworkGateway()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: .dismiss)
        FirebaseApp.configure()

        // TODO: - Check account max is not full.
        loadAndSaveInstagramAccountName { [weak self] result in
            switch result {
            case .success(let savedAccount):
                self?.showSuccessAlert(savedAccount)
            case .failure(let error):
                self?.showErrorAlert(error)
            }
        }
    }
}

fileprivate extension SaveAccountViewController {
    @objc func dismissAlertExtension() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        let returningItems = extensionContext?.inputItems
        extensionContext?.completeRequest(returningItems: returningItems)
    }

    func saveAccount(instagramEmbedded: InstagramEmbedded, result: @escaping ((Result<Account, Error>) -> Void)) {
        let account = Account(username: instagramEmbedded.authorName)
        networkGateway.addAccount(account) { addAccountResult in
            switch addAccountResult {
            case .success(let accountSaved):
                result(.success(accountSaved))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }

    func loadAndSaveInstagramAccountName(result: @escaping ((Result<Account, Error>) -> Void)) {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            result(.failure(ExtensionError.noContextItem))
            return
        }

        guard let provider = extensionItem.attachments?.first else {
            result(.failure(ExtensionError.noMedia))
            return
        }

        provider.loadItem(forTypeIdentifier: String(kUTTypeURL)) { [weak self] coding, error in
            if let error = error {
                result(.failure(error))
                return
            }

            guard let photoURL = coding as? URL else {
                result(.failure(URLError(.badURL)))
                return
            }

            let igEmbedUrlString = "https://api.instagram.com/oembed/?url=\(photoURL.absoluteString)"
            guard let igEmbedURL = URL(string: igEmbedUrlString) else {
                result(.failure(ExtensionError.embedURL))
                return
            }

            self?.getInstagramEmbedded(fromURL: igEmbedURL, result: result)
        }
    }

    func getInstagramEmbedded(fromURL url: URL, result: @escaping ((Result<Account, Error>) -> Void)) {
        networkGateway.getInstagramEmbedded(fromURL: url) { [weak self] embedResult in
            switch embedResult {
            case .success(let instagramEmbedded):
                DispatchQueue.main.async { [weak self] in
                    self?.saveAccount(instagramEmbedded: instagramEmbedded, result: result)
                }
            case .failure(let error):
                result(.failure(error))
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

    func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            self?.dismissAlertExtension()
        })

        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
}

fileprivate extension Selector {
    static let dismiss = #selector(SaveAccountViewController.dismissAlertExtension)
}
