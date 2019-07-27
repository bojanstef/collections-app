//
//  SearchViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

private enum Constants {
    static let yesterdayTimeInterval: TimeInterval = -24 * 60 * 60
}

final class SearchViewController: UIViewController {
    fileprivate let datePicker = UIDatePicker()
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    fileprivate var posts = [Post]()
    var presenter: SearchPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationItem.title = presenter.getTitleFromSearchedDate(Date())
        setDatePickerToMidnight()
        setupCollectionView(then: loadPosts)
    }
}

fileprivate extension SearchViewController {
    func setupCollectionView(then loadData: (() -> Void)) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = GridLayout()
        collectionView.alwaysBounceVertical = true
        collectionView.register(PostsCell.nib, forCellWithReuseIdentifier: PostsCell.reuseId)
        loadData()
    }

    func loadPosts() {
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now) ?? now
        presenter.loadPosts(after: yesterday) { [weak self] result in
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

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.navigateToPostDetail(posts[indexPath.row])
    }
}

extension SearchViewController: UICollectionViewDataSource {
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

fileprivate extension SearchViewController {
    @IBAction func searchButtonPressed(_ sender: Any) {
        let searchedDate = datePicker.date
        //presenter.searchAfterDate(searchedDate)
    }

    @IBAction func resetButtonPressed(_ sender: Any) {
        setDatePickerToMidnight()
    }

    @IBAction func scrapeAccountsButtonPressed(_ sender: Any) {
//        presenter.scrapeAccounts { [weak self] result in
//            switch result {
//            case .success:
//                self?.showScrapeResultAlert()
//            case .failure(let error):
//                self?.showScrapeResultAlert(error: error)
//            }
//        }
    }

    func setDatePickerToMidnight() {
        guard let midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: .init()) else {
            log.debug("Could not initializing a date.")
            return
        }

        datePicker.setDate(midnight, animated: true)
    }

    func showScrapeResultAlert(error: Error? = nil) {
        DispatchQueue.main.async { [weak self] in
            let title = error == nil ? "Success 🎉" : "Error 😱"
            let message = error?.localizedDescription ?? "Come back in 15 minutes or so to see the results."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            self?.present(alert, animated: true)
        }
    }
}
