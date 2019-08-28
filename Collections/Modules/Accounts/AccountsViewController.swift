//
//  AccountsViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import SafariServices
import FBSDKLoginKit

private enum Constants {
    static let headerViewMinHeight: CGFloat = 188
}

final class AccountsViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate var headerView = AccountsHeaderView()
    fileprivate var accounts = SortedSet<Account>()
    var presenter: AccountsPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Accounts"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .addAccount)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingsGlyph"), style: .plain, target: self, action: .openSettings)
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDidBecomeActive()
        NotificationCenter.default.addObserver(self, selector: .appDidBecomeActive, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

fileprivate extension AccountsViewController {
    @objc func addAccountToList() {
        let alert = UIAlertController(title: "Add Account", message: "Add an Instagram account by username to get content from", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            let textField = alert.textFields?.first
            self?.addAccount(username: textField?.text)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addTextField { $0.placeholder = "instagram" }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    @objc func openSettingsPressed() {
        presenter.navigateToSettings()
    }

    @objc func appDidBecomeActive() {
        loadAccounts()
        headerView.setMaxCount(presenter.accountsMax)
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountsCell.nib, forCellReuseIdentifier: AccountsCell.reuseId)

        headerView = AccountsHeaderView.nib()
        headerView.delegate = self
        headerView.frame.size.height = Constants.headerViewMinHeight
        tableView.tableHeaderView = headerView
    }

    func loadAccounts() {
        presenter.loadAccounts { [weak self] result in
            switch result {
            case .success(let accounts):
                DispatchQueue.main.async {
                    self?.headerView.setFollowingCount(accounts.count)
                    self?.accounts = SortedSet(accounts)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                log.error(error.localizedDescription)
                self?.showErrorAlert(AccountError.maximumReached)
            }
        }
    }

    func addAccount(username: String?) {
        guard let username = username?.lowercased() else {
            showErrorAlert(AccountError.empty)
            return
        }

        guard accounts.count < presenter.accountsMax else {
            showErrorAlert(AccountError.maximumReached)
            return
        }

        let account = Account(username: username)
        presenter.addAccount(account) { [weak self] result in
            switch result {
            case .success(let account):
                DispatchQueue.main.async { [weak self] in
                    self?.accounts.append(account)
                    self?.headerView.setFollowingCount(self?.accounts.count ?? 0)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                self?.showErrorAlert(error)
            }
        }
    }

    func callGetBusinessAccounts() {
        presenter.getBusinessAccounts { result in
            log.info(result)
        }
    }
}

extension AccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let username = accounts[indexPath.row].username
        let instagramURL = URL(string: "https://instagr.am/\(username)")!
        let safariViewController = SFSafariViewController(url: instagramURL)
        present(safariViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AccountsCell.cellHeight
    }
}

extension AccountsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAccount(at: indexPath)
        }
    }

    func deleteAccount(at indexPath: IndexPath) {
        let account = accounts[indexPath.row]
        presenter.deleteAccount(account) { [weak self] result in
            switch result {
            case .success:
                self?.accounts.remove(at: indexPath.row)
                self?.headerView.setFollowingCount(self?.accounts.count ?? 0)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: AccountsCell.reuseId, for: indexPath) as? AccountsCell)!
        cell.setup(with: accounts[indexPath.row])
        return cell
    }
}

extension AccountsViewController: AccountsHeaderViewDelegate {
    func instagramLogin(completion: @escaping (() -> Void)) {
        presenter.connectToInstagram { [weak self] result in
            completion()

            switch result {
            case .success:
                self?.callGetBusinessAccounts()
            case .failure(let error):
                log.error(error)
            }
        }
    }
}

fileprivate extension Selector {
    static let addAccount = #selector(AccountsViewController.addAccountToList)
    static let openSettings = #selector(AccountsViewController.openSettingsPressed)
    static let appDidBecomeActive = #selector(AccountsViewController.appDidBecomeActive)
}
