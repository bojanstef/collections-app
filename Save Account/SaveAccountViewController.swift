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
import CollectionsKit

private let log = Logger(category: "Action Extension")

final class SaveAccountViewController: UIViewController {
    fileprivate let networkGateway: SaveAccountAccessing = NetworkGateway()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: .donePressed)
        FirebaseApp.configure()
        loadAndSaveInstagramAccountName()
    }
}

fileprivate extension SaveAccountViewController {
    @objc func dismissAlertExtension() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        let returningItems = extensionContext?.inputItems
        extensionContext?.completeRequest(returningItems: returningItems)
    }

    func saveAccount(instagramEmbedded: InstagramEmbedded) {
        let account = Account(username: instagramEmbedded.authorName)
        networkGateway.addAccount(account) { [weak self] result in
            switch result {
            case .success(let accountSaved):
                self?.showSuccessAlert(accountSaved)
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }

    func loadAndSaveInstagramAccountName() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else { log.debug("No extension item"); return }
        guard let provider = extensionItem.attachments?.first else { log.debug("No provider"); return }
        provider.loadItem(forTypeIdentifier: String(kUTTypeURL)) { [weak self] coding, error in
            guard error == nil else { log.error(error!.localizedDescription); return }
            guard let photoURL = coding as? URL else { log.debug("Could not get URL"); return }
            let igEmbedUrlString = "https://api.instagram.com/oembed/?url=\(photoURL.absoluteString)"
            guard let igEmbedURL = URL(string: igEmbedUrlString) else { log.debug("Could not init IG Embed URL"); return }
            self?.getInstagramEmbedded(fromURL: igEmbedURL)
        }
    }

    func getInstagramEmbedded(fromURL url: URL) {
        networkGateway.getInstagramEmbedded(fromURL: url) { [weak self] result in
            switch result {
            case .success(let instagramEmbedded):
                DispatchQueue.main.async { [weak self] in
                    self?.saveAccount(instagramEmbedded: instagramEmbedded)
                }
            case .failure(let error):
                log.error(error.localizedDescription)
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
    static let donePressed = #selector(SaveAccountViewController.dismissAlertExtension)
}
