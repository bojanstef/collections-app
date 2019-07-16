//
//  SearchViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-15.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import FirebaseAuth

final class SearchViewController: UIViewController {
    var presenter: SearchPresentable!
}

fileprivate extension SearchViewController {
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            log.error(error.localizedDescription)
        }
    }
}
