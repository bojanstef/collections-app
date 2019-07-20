//
//  PostsViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class PostsViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    var presenter: PostsPresentable!
    private var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.getTitleFromSearchedDate()
        setupCollectionView()
        loadPosts()
    }
}

fileprivate extension PostsViewController {
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = GridLayout()
        collectionView.alwaysBounceVertical = true
        collectionView.register(PostsCell.nib, forCellWithReuseIdentifier: PostsCell.reuseId)
    }

    func loadPosts() {
        presenter.loadPosts { [weak self] result in
            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    self?.posts = posts
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }
}

extension PostsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
//        dataManager.postSelected = posts[indexPath.row]
//        let postDetailVC = UIStoryboard.instantiateInitialViewController(PostDetailViewController.self)
//        navigationController?.pushViewController(postDetailVC, animated: true)
    }
}

extension PostsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast line_length
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostsCell.reuseId, for: indexPath) as! PostsCell
        cell.setup(with: posts[indexPath.row])
        return cell
    }
}
