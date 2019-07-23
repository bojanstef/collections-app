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
    fileprivate var posts = [Post]()
    var presenter: PostsPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.getTitleFromSearchedDate()
        setupCollectionView(then: loadPosts)
    }
}

fileprivate extension PostsViewController {
    func setupCollectionView(then loadData: (() -> Void)) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = GridLayout()
        collectionView.alwaysBounceVertical = true
        collectionView.register(PostsCell.nib, forCellWithReuseIdentifier: PostsCell.reuseId)
        loadData()
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
        presenter.navigateToPostDetail(posts[indexPath.row])
    }
}

extension PostsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: PostsCell.reuseId, for: indexPath) as? PostsCell)!
        cell.setup(with: posts[indexPath.row])
        return cell
    }
}
