//
//  ActionViewController.swift
//  Save Account
//
//  Created by Bojan Stefanovic on 2019-07-25.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import MobileCoreServices

final class ActionViewController: UIViewController {
    @IBOutlet fileprivate weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: .cancelPressed)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: .savePressed)

        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else { print("No extension item"); return }
        guard let provider = extensionItem.attachments?.first else { print("No provider"); return }
        provider.loadItem(forTypeIdentifier: String(kUTTypeURL)) { [weak self] coding, error in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let photoURL = coding as? URL else { print("Could not get URL"); return }
            let igEmbedUrlString = "https://api.instagram.com/oembed/?url=\(photoURL.absoluteString)"
            guard let igEmbedURL = URL(string: igEmbedUrlString) else { print("Could not init IG Embed URL"); return }
            self?.loadJSON(fromURL: igEmbedURL)
        }
    }
}

fileprivate extension ActionViewController {
    @objc func cancelPressed() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        let returningItems = extensionContext?.inputItems
        extensionContext?.completeRequest(returningItems: returningItems)
    }

    @objc func savePressed() {
        // TODO: - Actually save the username.
        cancelPressed()
    }

    func loadJSON(fromURL url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else { print(error!); return }
            guard let httpResponse = response as? HTTPURLResponse else {
                // TODO: - Add custom error.
                print("Response is not a HTTPURLResponse")
                return
            }

            guard 200...299 ~= httpResponse.statusCode else {
                // TODO: - Add custom error.
                print("Error status code \(httpResponse.statusCode)")
                return
            }

            print(response.debugDescription)

            guard let data = data else {
                print("No data")
                return
            }

            do {
                // TODO: - Move Models to CollectionKit and create Model for https://www.instagram.com/developer/embedding/#oembed
                guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
                    throw NSError(domain: "Could not cast jsonObject as dictionary", code: 0, userInfo: [:])
                }

                print(json)
                if let accountUsername = json["author_name"] as? String {
                    DispatchQueue.main.async {
                        self?.usernameLabel.text = "@" + accountUsername
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }
}

fileprivate extension Selector {
    static let cancelPressed = #selector(ActionViewController.cancelPressed)
    static let savePressed = #selector(ActionViewController.savePressed)
}
