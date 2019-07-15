//
//  UIStoryboard+DependencyInjection.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

extension UIStoryboard {
    // swiftlint:disable:next line_length
    static func instantiateInitialViewController<T: UIViewController>(_ viewControllerType: T.Type, completion: ((T) -> Void)) -> T {
        let storyboardName = String(describing: viewControllerType)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! T // swiftlint:disable:this force_cast
        completion(viewController)
        return viewController
    }
}
