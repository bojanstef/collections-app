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

        setup(creditsCollectionView, cell: CreditsCard.self, fetchOnce: nil)
        setup(maxAccountsCollectionView, cell: MaxAccountsCard.self, fetchOnce: fetchProducts)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicator.frame = view.bounds
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let creditsBundle = credits[indexPath.row]
        presenter.purchase(
            credits: creditsBundle,
            start: { [weak self] in
                self?.activityIndicator.startAnimating()
            },
            result: { [weak self] result in
                self?.activityIndicator.stopAnimating()

                switch result {
                case .success:
                    self?.upload(credits: creditsBundle)
                case .failure(let error):
                    log.error(error.localizedDescription)
                }
            })
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
        switch collectionView {
        case creditsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreditsCard.reuseId, for: indexPath) as? CreditsCard
            cell?.setup(with: credits[indexPath.row])
            return cell!
        case maxAccountsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MaxAccountsCard.reuseId, for: indexPath) as? MaxAccountsCard
            cell?.setup(with: maxAccounts[indexPath.row])
            return cell!
        default:
            fatalError("CollectionView: \(collectionView) does not exist.")
        }
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

    func upload(credits: Credit) {
        presenter.upload(credits: credits) { result in
            switch result {
            case .success:
                log.info("Successfully added more credits")
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }

    func runSignOut() {
        do {
            try presenter.signOut()
        } catch {
            log.error(error)
        }
    }

    func setup<T: NibReusable>(_ collectionView: UICollectionView, cell: T.Type, fetchOnce: (() -> Void)?) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = CardLayout()
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(cell.nib, forCellWithReuseIdentifier: cell.reuseId)
        fetchOnce?()
    }

    func fetchProducts() {
        presenter.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async { [weak self] in
                    self?.credits = products.credits.sorted(by: >)
                    self?.creditsCollectionView.reloadData()
                    self?.maxAccounts = products.maxAccounts.sorted(by: >)
                    self?.maxAccountsCollectionView.reloadData()
                }
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }
}
