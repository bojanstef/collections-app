//
//  SearchViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

private enum Constants {
    static let searchTitle = "Search"
    static let blurViewAnimationDuration: TimeInterval = 0.4
    static let blurAlphaMax: CGFloat = 0.75
}

final class SearchViewController: UIViewController {
    fileprivate let dummyTextField = UITextField(frame: .zero)
    fileprivate let navigationTitleButton = UIButton(type: .system)
    fileprivate let datePicker = UIDatePicker()
    fileprivate let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    fileprivate var posts = [Post]()
    var presenter: SearchPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.searchTitle
        blurView.alpha = 0
        setupNavigationItem()
        setupCollectionView(then: loadPosts)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        cancelDatePicker()
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
    func setupNavigationItem() {
        let toolbar = UIToolbar()
        toolbar.items = [
            .init(barButtonSystemItem: .cancel, target: self, action: .cancelDatePicker),
            .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            .init(title: Constants.searchTitle, style: .plain, target: self, action: .setDate)
        ]
        toolbar.sizeToFit()

        dummyTextField.inputView = datePicker
        dummyTextField.inputAccessoryView = toolbar
        dummyTextField.autocorrectionType = .no
        dummyTextField.inputAssistantItem.leadingBarButtonGroups.removeAll()
        dummyTextField.inputAssistantItem.trailingBarButtonGroups.removeAll()

        navigationTitleButton.setTitle(Constants.searchTitle, for: .normal)
        navigationTitleButton.addTarget(self, action: .showDatePicker, for: .touchUpInside)
        navigationTitleButton.addSubview(dummyTextField)
        navigationItem.titleView = navigationTitleButton
    }

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

    func addBlurView() {
        blurView.frame = view.bounds
        view.addSubview(blurView)
        UIView.animate(withDuration: Constants.blurViewAnimationDuration) { [weak self] in
            self?.blurView.alpha = Constants.blurAlphaMax
        }
    }

    func removeBlurView() {
        UIView.animate(withDuration: Constants.blurViewAnimationDuration, animations: { [weak self] in
            self?.blurView.alpha = 0
        }) { [weak self] _ in
            self?.blurView.removeFromSuperview()
        }
    }

    @IBAction func searchButtonPressed(_ sender: Any) {
        let searchedDate = datePicker.date
        //presenter.searchAfterDate(searchedDate)
    }

    @IBAction func scrapeAccountsButtonPressed(_ sender: Any) {
        // TODO: - Fix
//        presenter.scrapeAccounts { [weak self] result in
//            switch result {
//            case .success:
//                self?.showScrapeResultAlert()
//            case .failure(let error):
//                self?.showScrapeResultAlert(error: error)
//            }
//        }
    }

    @objc func showDatePicker() {
        addBlurView()
        dummyTextField.becomeFirstResponder()
    }

    @objc func setDate() {
        let dateTitle = presenter.getTitleFromSearchedDate(datePicker.date)
        navigationTitleButton.setTitle(dateTitle, for: .normal)
        dummyTextField.resignFirstResponder()

        // TODO: - make network request and upon completion call removeBlurView
        removeBlurView()
    }

    @objc func cancelDatePicker() {
        removeBlurView()
        dummyTextField.resignFirstResponder()
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

fileprivate extension Selector {
    static let showDatePicker = #selector(SearchViewController.showDatePicker)
    static let setDate = #selector(SearchViewController.setDate)
    static let cancelDatePicker = #selector(SearchViewController.cancelDatePicker)
}
