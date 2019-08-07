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
    fileprivate var creditPackages = ["best", "better", "good", "okay", "mediocre"]
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
        if collectionView == creditsCollectionView {
            return creditPackages.count
        } else if collectionView == maxAccountsCollectionView {
            return maxAccounts.count
        } else {
            fatalError("Whose mans is this?")
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: CreditsCard.reuseId, for: indexPath) as? CreditsCard)!

        if collectionView == creditsCollectionView {
            cell.setup(with: creditPackages[indexPath.row])
        } else if collectionView == maxAccountsCollectionView {
            cell.setup(with: "\(maxAccounts[indexPath.row])")
        } else {
            fatalError("Whose mans is this?")
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

    func setupCreditsCollectionView() {
        creditsCollectionView.dataSource = self
        creditsCollectionView.delegate = self
        creditsCollectionView.collectionViewLayout = CardLayout()
        creditsCollectionView.alwaysBounceHorizontal = true
        creditsCollectionView.register(CreditsCard.nib, forCellWithReuseIdentifier: CreditsCard.reuseId)
    }

    func setupMaxAccountsCollectionView() {
        maxAccountsCollectionView.dataSource = self
        maxAccountsCollectionView.delegate = self
        maxAccountsCollectionView.collectionViewLayout = CardLayout()
        maxAccountsCollectionView.alwaysBounceHorizontal = true
        maxAccountsCollectionView.register(CreditsCard.nib, forCellWithReuseIdentifier: CreditsCard.reuseId)
    }
}
