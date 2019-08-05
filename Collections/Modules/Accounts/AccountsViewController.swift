//
//  AccountsViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-17.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import SafariServices
import CollectionsKit

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
        navigationItem.title = "Accounts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .addAccount)
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAccounts()
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

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountsCell.nib, forCellReuseIdentifier: AccountsCell.reuseId)

        let headerView = AccountsHeaderView.nib()
        headerView.delegate = self
        tableView.tableHeaderView = headerView
    }

    func loadAccounts() {
        presenter.loadAccounts { [weak self] result in
            switch result {
            case .success(let accounts):
                DispatchQueue.main.async {
                    self?.accounts = accounts.sorted()
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
    func getPhotos() {
        presenter.scrapeAccounts { [weak self] result in
            switch result {
            case .success:
                self?.showScrapeResultAlert()
            case .failure(let error):
                self?.showScrapeResultAlert(error: error)
            }
        }
    }
}

fileprivate extension Selector {
    static let addAccount = #selector(AccountsViewController.addAccountToList)
}
