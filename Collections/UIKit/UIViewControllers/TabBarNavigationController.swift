//
//  TabBarNavigationController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-29.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

private enum Constants {
    static let tabBarInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
}

final class TabBarNavigationController: UINavigationController {
    enum ControllerType {
        case search, accounts
    }

    private let type: TabBarNavigationController.ControllerType

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(_ type: TabBarNavigationController.ControllerType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = .black

        let image: UIImage?
        let selectedImage: UIImage?
        switch type {
        case .search:
            image = UIImage(named: "search")
            selectedImage = UIImage(named: "searchFilled")
        case .accounts:
            image = UIImage(named: "account")
            selectedImage = UIImage(named: "accountFilled")
        }

        tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
        tabBarItem.imageInsets = Constants.tabBarInsets
        tabBarController?.selectedIndex = 0
    }
}
