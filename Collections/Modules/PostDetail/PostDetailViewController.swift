//
//  PostDetailViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-22.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

private enum Constants {
    static let taggedPrefix = "Tagged users"
}

final class PostDetailViewController: UIViewController {
    @IBOutlet fileprivate weak var usernameLabel: UILabel!
    @IBOutlet fileprivate weak var locationLabel: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    var presenter: PostDetailPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let image = presenter.post.getImage() {
            setupImageView(with: image)
        }
    }
}

fileprivate extension PostDetailViewController {
    func setup() {
        let post = presenter.post
        usernameLabel.text = "@" + post.ownerUsername
        locationLabel.text = post.taggedLocation
        descriptionLabel.attributedText = generateAttributedDescription(post.description)
//        taggedUsersLabel.backgroundColor = .init(white: 1, alpha: 0.5)
//        taggedUsersLabel.text = generateTaggedUsersText(post.taggedUsernames)
    }

    func generateAttributedDescription(_ description: String?) -> NSAttributedString? {
        guard let description = description else { return nil }
        return NSAttributedString(string: description)
    }

    func generateTaggedUsersText(_ usernames: [String]) -> String? {
        guard !usernames.isEmpty else { return nil }
        let usersText = usernames.reduce("") { $0 + "@" + $1 + "\n" }
        return Constants.taggedPrefix + "\n" + usersText
    }

    func setupImageView(with image: UIImage) {
        guard let imageData = image.pngData() else {
            log.debug("Could not load png data from UIImage")
            return
        }

        imageView.image = UIImage(data: imageData)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: .saveImage))

        imageView.layoutIfNeeded() // TODO: - Figure out why I have to call layoutIfNeeded first (I always thought it was after)?
        let ratio = image.size.width / image.size.height
        let newHeight = imageView.bounds.width / ratio
        imageViewHeight.constant = newHeight
    }

    @objc func saveImage(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began, let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, .imageSaved, nil)
    }

    @objc func imageSaved(_ image: UIImage, with error: Error?, contextInfo: UnsafeRawPointer) {
        let message = error?.localizedDescription ?? "Image Saved"
        let title = error != nil ? "Whoops" : "Done"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

fileprivate extension Selector {
    static let saveImage = #selector(PostDetailViewController.saveImage(_:))
    static let imageSaved = #selector(PostDetailViewController.imageSaved(_:with:contextInfo:))
}
