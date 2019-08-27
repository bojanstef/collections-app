//
//  SettingsViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import SafariServices

final class SettingsViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var toolbar: Toolbar!
    fileprivate var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    fileprivate var maxAccounts = [MaxAccount]()
    var presenter: SettingsPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        activityIndicator.backgroundColor = .init(white: 0.5, alpha: 0.5)
        view.addSubview(activityIndicator)
        setupCollectionView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: .restoreSubscription)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.frame = view.bounds
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let maxAccountsBundle = maxAccounts[indexPath.row]
        presenter.purchase(
            maxAccounts: maxAccountsBundle,
            start: { [weak self] in self?.activityIndicator.startAnimating() },
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
    }
}

extension SettingsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxAccounts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCard = collectionView.dequeueReusableCell(for: indexPath)
        cell.setup(with: maxAccounts[indexPath.row])
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

    @IBAction func termsPressed(_ sender: Any) {
        showBrowser(atLink: "https://www.websitepolicies.com/policies/view/5766dP6f")
    }

    @IBAction func privacyPressed(_ sender: Any) {
        showBrowser(atLink: "https://www.websitepolicies.com/policies/view/KpS1rFwU")
    }

    func showBrowser(atLink urlString: String) {
        let url = URL(string: urlString)!
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }

    func runSignOut() {
        do {
            try presenter.signOut()
        } catch {
            log.error(error)
        }
    }

    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = CardLayout()
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(ProductCard.nib, forCellWithReuseIdentifier: ProductCard.reuseId)
        presenter.fetchProducts { [weak self] result in
            switch result {
            case .success(let maxAccounts):
                DispatchQueue.main.async {
                    self?.maxAccounts = maxAccounts.sorted(by: >)
                    self?.collectionView.reloadData()
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
