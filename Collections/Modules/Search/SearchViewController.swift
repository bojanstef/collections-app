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
    static let resetTitle = "Reset"
    static let blurViewAnimationDuration: TimeInterval = 0.4
    static let blurAlphaMax: CGFloat = 0.25
    static let twentyFourHours: TimeInterval = 60 * 60 * 24
}

final class SearchViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate let dummyTextField = DummyTextField()
    fileprivate let navigationTitleButton = NavigationTitleButton(type: .system)
    fileprivate let datePicker = UIDatePicker()
    fileprivate let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    fileprivate var posts = [Post]()
    var presenter: SearchPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.searchTitle
        blurView.alpha = 0
        setupNavigationItem()
        setupCollectionView(then: loadPosts)
        refreshControl.addTarget(self, action: .searchPressed, for: .valueChanged)
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
    var lastMidnightOrYesterday: Date {
        let now = Date()
        let lastMidnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: now)
        let aDayAgo = Date(timeIntervalSinceNow: -Constants.twentyFourHours)
        return lastMidnight ?? aDayAgo
    }

    func setupNavigationItem() {
        let toolbar = UIToolbar()
        toolbar.items = [
            BarButtonItem(barButtonSystemItem: .cancel, target: self, action: .cancelDatePicker),
            BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            BarButtonItem(title: Constants.resetTitle, style: .plain, target: self, action: .resetPressed),
            BarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            BarButtonItem(title: Constants.searchTitle, style: .plain, target: self, action: .searchPressed)
        ]
        toolbar.sizeToFit()

        dummyTextField.inputView = datePicker
        dummyTextField.inputAccessoryView = toolbar

        let navTitleButtonWidth = view.bounds.width - 128
        let navTitleButtonHeight = navigationController?.navigationBar.bounds.height ?? .zero
        navigationTitleButton.frame = CGRect(x: 0, y: 0, width: navTitleButtonWidth, height: navTitleButtonHeight)
        navigationTitleButton.setTitle(Constants.searchTitle, for: .normal)
        navigationTitleButton.setImage(UIImage(named: "expandArrow"), for: .normal)
        navigationTitleButton.addTarget(self, action: .showDatePicker, for: .touchUpInside)
        navigationTitleButton.addSubview(dummyTextField)
        navigationTitleButton.layoutIfNeeded()
        navigationItem.titleView = navigationTitleButton
    }

    func setupCollectionView(then loadData: ((Date?, (() -> Void)?) -> Void)) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        collectionView.collectionViewLayout = GridLayout()
        collectionView.alwaysBounceVertical = true
        collectionView.register(PostsCell.nib, forCellWithReuseIdentifier: PostsCell.reuseId)
        loadData(nil, nil)
    }

    func loadPosts(after date: Date? = nil, completion: (() -> Void)? = nil) {
        let searchDate = date ?? lastMidnightOrYesterday
        presenter.loadPosts(after: searchDate) { [weak self] result in
            completion?()

            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    self?.updateCollectionView(with: posts)
                }
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }

    func updateCollectionView(with posts: [Post]) {
        self.posts = posts
        collectionView.reloadData()

        guard posts.isEmpty else {
            collectionView.backgroundView = nil
            return
        }

        let emptyPostView = EmptyPostsView.nib()
        emptyPostView.frame = collectionView.bounds
        collectionView.backgroundView = emptyPostView
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
        }, completion: { [weak self] _ in
            self?.blurView.removeFromSuperview()
        })
    }

    @objc func showDatePicker() {
        guard !dummyTextField.isFirstResponder else {
            cancelDatePicker()
            return
        }

        addBlurView()
        dummyTextField.becomeFirstResponder()
    }

    @objc func searchPressed() {
        let searchDate = dummyTextField.isFirstResponder ? datePicker.date : lastMidnightOrYesterday
        let dateTitle = presenter.getTitleFromSearchedDate(searchDate)
        navigationTitleButton.setTitle(dateTitle, for: .normal)
        dummyTextField.resignFirstResponder()

        loadPosts(after: searchDate) { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.removeBlurView()
        }
    }

    @objc func cancelDatePicker() {
        removeBlurView()
        dummyTextField.resignFirstResponder()
    }

    @objc func resetPressed() {
        datePicker.setDate(lastMidnightOrYesterday, animated: true)
    }
}

fileprivate extension Selector {
    static let showDatePicker = #selector(SearchViewController.showDatePicker)
    static let searchPressed = #selector(SearchViewController.searchPressed)
    static let cancelDatePicker = #selector(SearchViewController.cancelDatePicker)
    static let resetPressed = #selector(SearchViewController.resetPressed)
}
