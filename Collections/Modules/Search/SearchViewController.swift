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
        log.info(#function)
    }

    func setDatePickerToMidnight() {
        guard let midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: .init()) else {
            log.debug("Could not initializing a date.")
            return
        }

        datePicker.setDate(midnight, animated: true)
    }
}
