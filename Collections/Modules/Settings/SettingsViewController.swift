//
//  SettingsViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-04.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import StoreKit
import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet fileprivate weak var creditsCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var maxAccountsCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var toolbar: UIToolbar!
    fileprivate var credits = [SKProduct]()
    fileprivate var maxAccounts = [5, 10, 25, 50, 100]
    var presenter: SettingsPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        toolbar.tintColor = .lightGray
        setupCreditsCollectionView()
        setupMaxAccountsCollectionView()
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //presenter.navigateToPostDetail(posts[indexPath.row])
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCard.reuseId, for: indexPath) as? ProductCard

        switch collectionView {
        case creditsCollectionView:
            cell?.setup(with: credits[indexPath.row])
        case maxAccountsCollectionView:
            //cell?.setup(with: credits[indexPath.row])
            break
        default:
            fatalError("CollectionView: \(collectionView) does not exist.")
        }

        return cell!
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

    func setupCreditsCollectionView() {
        creditsCollectionView.dataSource = self
        creditsCollectionView.delegate = self
        creditsCollectionView.collectionViewLayout = CardLayout()
        creditsCollectionView.alwaysBounceHorizontal = true
        creditsCollectionView.register(ProductCard.nib, forCellWithReuseIdentifier: ProductCard.reuseId)
        presenter.fetchProducts(ofType: .credits) { [weak self] result in
            switch result {
            case .success(let credits):
                DispatchQueue.main.async { [weak self] in
                    self?.credits = credits
                    self?.creditsCollectionView.reloadData()
                }
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }

    func setupMaxAccountsCollectionView() {
        maxAccountsCollectionView.dataSource = self
        maxAccountsCollectionView.delegate = self
        maxAccountsCollectionView.collectionViewLayout = CardLayout()
        maxAccountsCollectionView.alwaysBounceHorizontal = true
        maxAccountsCollectionView.register(ProductCard.nib, forCellWithReuseIdentifier: ProductCard.reuseId)
//        presenter.fetchProducts(ofType: .accountsMax) { [weak self] result in
//            switch result {
//            case .success(let credits):
//                DispatchQueue.main.async { [weak self] in
//                    self?.credits = credits
//                    self?.creditsCollectionView.reloadData()
//                }
//            case .failure(let error):
//                log.error(error.localizedDescription)
//            }
//        }
    }
}
