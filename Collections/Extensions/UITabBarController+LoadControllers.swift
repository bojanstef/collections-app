//
//  UITabBarController+LoadControllers.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-26.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

extension UITabBarController {
    func loadControllers(_ viewControllers: [UIViewController], animated: Bool) {
        setViewControllers(viewControllers, animated: animated)
        self.viewControllers?.forEach { _ = $0.view }
    }
}
