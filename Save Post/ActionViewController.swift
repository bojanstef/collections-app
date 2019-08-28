//
//  ActionViewController.swift
//  Save Post
//
//  Created by Bojan Stefanovic on 2019-08-23.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

final class ActionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        saveMedia { [weak self] result in
            switch result {
            case .success:
                self?.showSuccessAlert()

            case .failure(let error):
                self?.showErrorAlert(error, okHandler: { [weak self] _ in
                    self?.dismissAlertExtension()
                })
            }
        }
    }
}

extension NSError {
    convenience init(domain: String) {
        self.init(domain: domain, code: 0, userInfo: nil)
    }
}

fileprivate extension ActionViewController {
    @objc func dismissAlertExtension() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        let returningItems = extensionContext?.inputItems
        extensionContext?.completeRequest(returningItems: returningItems)
    }

    func saveMedia(result: @escaping ((Result<Void, Error>) -> Void)) {
        do {
            guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else { throw NSError(domain: "no context item") }
            guard let provider = extensionItem.attachments?.first else { throw NSError(domain: "no media") }
            provider.loadItem(forTypeIdentifier: String(kUTTypeURL)) { [weak self] coding, error in
                if let error = error { result(.failure(error)); return }
                guard let shareURL = coding as? URL, let mediaURL = self?.generateMediaURL(fromURL: shareURL) else { result(.failure(URLError(.badURL))); return }
                self?.downloadMedia(fromURL: mediaURL, result: result)
            }
        } catch {
            result(.failure(error))
        }
    }

    /**
     * - Parameter url: A raw share sheet URL https://www.instagram.com/p/B1hbYIIBZft/?igshid=1xmviypn6edwu
     * - Algorithm description
     *      - `split(by: "?")`
     *      - `.first`
     *      - add media query "media/?size=l"
     * - Returns: A media URL
     */
    func generateMediaURL(fromURL url: URL) -> URL? {
        let splitStr = url.absoluteString.split(separator: "?")
        guard let shortURLString = splitStr.first else { return nil }
        let mediaURLStr = shortURLString.appending("media/?size=l")
        return URL(string: mediaURLStr)
    }

    func downloadMedia(fromURL url: URL, result: @escaping ((Result<Void, Error>) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                if let error = error { throw error }
                guard let urlResponse = response as? HTTPURLResponse, urlResponse.isSuccessCode else { throw URLError(.badServerResponse) }
                guard let data = data else { throw NSError(domain: "no data") }
                guard let image = UIImage(data: data) else { throw NSError(domain: "couldn't create image from data") }
                PhotoAlbum.shared.saveImage(image, result: result)
            } catch {
                result(.failure(error))
            }
        }.resume()
    }

    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Post saved", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            self?.dismissAlertExtension()
        })

        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
}
