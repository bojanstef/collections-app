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
    fileprivate var maxAccounts = [Int]()
    var presenter: SettingsPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        toolbar.tintColor = .lightGray
        activityIndicator.backgroundColor = .init(white: 0.5, alpha: 0.5)
        view.addSubview(activityIndicator)

        setupCreditsCollectionView()
        setupMaxAccountsCollectionView()
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
                let completion: (() -> Void) = { [weak self] in
                    self?.activityIndicator.stopAnimating()
                }

                switch result {
                case .success:
                    self?.upload(credits: creditsBundle, completion: completion)
                case .failure(let error):
                    completion()
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

    func upload(credits: Credit, completion: @escaping (() -> Void)) {
        presenter.upload(credits: credits) { result in
            completion()

            switch result {
            case .success:
                break
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

    func setupCreditsCollectionView() {
        creditsCollectionView.dataSource = self
        creditsCollectionView.delegate = self
        creditsCollectionView.collectionViewLayout = CardLayout()
        creditsCollectionView.alwaysBounceHorizontal = true
        creditsCollectionView.register(ProductCard.nib, forCellWithReuseIdentifier: ProductCard.reuseId)
        presenter.fetchCredits { result in
            switch result {
            case .success(let credits):
                DispatchQueue.main.async { [weak self] in
                    self?.credits = credits.sorted(by: >)
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
//        presenter.fetchProducts(ofType: .accountMax) { [weak self] result in
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
