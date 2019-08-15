//
//  SettingsViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet fileprivate weak var creditsCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var maxAccountsCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var toolbar: UIToolbar!
    fileprivate var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    fileprivate var credits = [Credit]()
    fileprivate var maxAccounts = [MaxAccount]()
    var presenter: SettingsPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        toolbar.tintColor = .lightGray
        activityIndicator.backgroundColor = .init(white: 0.5, alpha: 0.5)
        view.addSubview(activityIndicator)
        setup(creditsCollectionView, maxAccountsCollectionView, cell: ProductCard.self, fetchOnce: fetchProducts)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: .restoreSubscription)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.frame = view.bounds
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let start: (() -> Void) = { [weak self] in self?.activityIndicator.startAnimating() }

        switch collectionView {
        case creditsCollectionView:
            let creditsBundle = credits[indexPath.row]
            presenter.purchase(
                credits: creditsBundle,
                start: start,
                result: { [weak self] result in
                    self?.activityIndicator.stopAnimating()

                    switch result {
                    case .success:
                        log.info("Purchased \(creditsBundle)!")
                    case .failure(let error):
                        let errorAlert = ErrorAlertFactory.getAlert(error)
                        self?.present(errorAlert, animated: true)
                    }
            })
        case maxAccountsCollectionView:
            let maxAccountsBundle = maxAccounts[indexPath.row]
            presenter.purchase(
                maxAccounts: maxAccountsBundle,
                start: start,
                result: { [weak self] result in
                    self?.activityIndicator.stopAnimating()

                    switch result {
                    case .success:
                        log.info("Purchased \(maxAccountsBundle)!")
                    case .failure(let error):
                        let errorAlert = ErrorAlertFactory.getAlert(error)
                        self?.present(errorAlert, animated: true)
                    }
            })
        default:
            fatalError("CollectionView: \(collectionView) does not exist.")
        }
    }
}

extension SettingsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case creditsCollectionView:
            return credits.count
        case maxAccountsCollectionView:
            return maxAccounts.count
        default:
            fatalError("CollectionView: \(collectionView) does not exist.")
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCard = collectionView.dequeueReusableCell(for: indexPath)

        switch collectionView {
        case creditsCollectionView:
            cell.setup(with: credits[indexPath.row])
        case maxAccountsCollectionView:
            cell.setup(with: maxAccounts[indexPath.row])
        default:
            fatalError("CollectionView: \(collectionView) does not exist.")
        }

        return cell
    }
}

fileprivate extension SettingsViewController {
    @IBAction func signOutPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.runSignOut()
        }))

        present(alert, animated: true)
    }

    func runSignOut() {
        do {
            try presenter.signOut()
        } catch {
            log.error(error)
        }
    }

    func setup<T: NibReusable>(_ collectionViews: UICollectionView..., cell: T.Type, fetchOnce: (() -> Void)?) {
        collectionViews.forEach {
            $0.dataSource = self
            $0.delegate = self
            $0.collectionViewLayout = CardLayout()
            $0.alwaysBounceHorizontal = true
            $0.register(cell.nib, forCellWithReuseIdentifier: cell.reuseId)
        }

        fetchOnce?()
    }

    func fetchProducts() {
        presenter.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self?.credits = products.credits.sorted(by: >)
                    self?.creditsCollectionView.reloadData()
                    self?.maxAccounts = products.maxAccounts.sorted(by: >)
                    self?.maxAccountsCollectionView.reloadData()
                }
            case .failure(let error):
                self?.showErrorAlert(error)
            }
        }
    }

    @objc func restoreSubscription() {
        activityIndicator.startAnimating()

        presenter.restoreSubscription { [weak self] result in
            self?.activityIndicator.stopAnimating()
            switch result {
            case .success:
                log.info("Success")
            case .failure(let error):
                self?.showErrorAlert(error)
            }
        }
    }
}

fileprivate extension Selector {
    static let restoreSubscription = #selector(SettingsViewController.restoreSubscription)
}
