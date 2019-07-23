//
//  AccountsViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class AccountsViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    fileprivate var accountsSet = Set<Account>()
    fileprivate var accounts = [Account]() {
        didSet {
            accountsSet = Set(accountsSet)
        }
    }

    var presenter: AccountsPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Accounts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .addAccount)
        setupTableView(then: loadAccounts)
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

    func setupTableView(then loadData: @escaping (() -> Void)) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountsCell.nib, forCellReuseIdentifier: AccountsCell.reuseId)
        loadData()
    }

    func loadAccounts() {
        presenter.loadAccounts { [weak self] result in
            switch result {
            case .success(let accounts):
                DispatchQueue.main.async {
                    self?.accounts = accounts
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }

    func addAccount(username: String?) {
        guard let username = username?.lowercased() else {
            log.error("Must supply a username") // TODO: - Show info here (UX).
            return
        }

        let account = Account(username: username)
        guard !accountsSet.contains(account) else {
            log.error("This username already exists") // TODO: - Show info here (UX).
            return
        }

        presenter.addAccount(account) { [weak self] result in
            switch result {
            case .success(let account):
                DispatchQueue.main.async {
                    self?.accounts.append(account)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }
}

extension AccountsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let username = accounts[indexPath.row].username

        // TODO: - Clean this shit up.
        let instagramAppDeepLink = "instagram://user?username=\(username)"
        let instagramAppURL = URL(string: instagramAppDeepLink)!

        if UIApplication.shared.canOpenURL(instagramAppURL) {
            UIApplication.shared.open(instagramAppURL, options: [:])
        } else {
            let instagramWebLink = "https://instagr.am/\(username)"
            let instagramWebURL = URL(string: instagramWebLink)!
            UIApplication.shared.open(instagramWebURL, options: [:])
        }
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

fileprivate extension Selector {
    static let addAccount = #selector(AccountsViewController.addAccountToList)
}
