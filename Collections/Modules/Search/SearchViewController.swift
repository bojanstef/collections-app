//
//  SearchViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

private enum Constants {
    static let yesterdayTimeInterval: TimeInterval = -24 * 60 * 60
}

final class SearchViewController: UIViewController {
    @IBOutlet fileprivate weak var datePicker: UIDatePicker!
    var presenter: SearchPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setDatePickerToMidnight()
    }
}

fileprivate extension SearchViewController {
    @IBAction func searchButtonPressed(_ sender: Any) {
        let searchedDate = datePicker.date
        presenter.searchAfterDate(searchedDate)
    }

    @IBAction func resetButtonPressed(_ sender: Any) {
        setDatePickerToMidnight()
    }

    @IBAction func accountsToScrapeButtonPressed(_ sender: Any) {
        presenter.navigateToAccounts()
    }

    @IBAction func scrapeAccountsButtonPressed(_ sender: Any) {
        presenter.scrapeAccounts { [weak self] result in
            switch result {
            case .success:
                self?.showScrapeResultAlert()
            case .failure(let error):
                self?.showScrapeResultAlert(error: error)
            }
        }
    }

    func setDatePickerToMidnight() {
        guard let midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: .init()) else {
            log.debug("Could not initializing a date.")
            return
        }

        datePicker.setDate(midnight, animated: true)
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
