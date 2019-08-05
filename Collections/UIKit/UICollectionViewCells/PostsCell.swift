//
//  PostsCell.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class PostsCell: UICollectionViewCell, NibReusable {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var followerCountLabel: UILabel!
    fileprivate var dataTask: URLSessionDataTask?

    override func prepareForReuse() {
        super.prepareForReuse()
        dataTask?.cancel()
        imageView.image = nil
    }

    func setup(with post: Post) {
        setupFollowerLabel(with: post.followerCount)
        downloadImage(for: post)
    }
}

fileprivate extension PostsCell {
    func setupFollowerLabel(with followerCount: Int?) {
        followerCountLabel.backgroundColor = .init(white: 0.5, alpha: 0.5)
        followerCountLabel.font = .systemFont(ofSize: 12)
        followerCountLabel.textColor = .init(white: 1, alpha: 1)

        guard let followerCount = followerCount else {
            followerCountLabel.text = "No followers"
            return
        }

        // TODO: - Create a custom number formatter
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let number = NSNumber(value: followerCount)
        let followers = formatter.string(from: number)
        followerCountLabel.text = followers
    }

    func downloadImage(for post: Post) {
        guard let url = URL(string: post.displayUrl) else {
            log.info("Error initializing image URL \(post.displayUrl)")
            return
        }

        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil else { log.error(error!.localizedDescription); return }
            guard let data = data, let response = response else { return }

            log.debug(response.debugDescription)

            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                post.saveImage(image)
                self?.imageView.image = UIImage(data: data)

            }
        }

        dataTask?.resume()
    }
}
