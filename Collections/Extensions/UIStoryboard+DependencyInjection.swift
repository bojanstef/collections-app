//
//  UIStoryboard+DependencyInjection.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-07-11.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiateInitialViewController<T: UIViewController>(_ viewControllerType: T.Type, completion: ((T) -> Void)? = nil) -> T {
        let storyboardName = String(describing: viewControllerType)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! T // swiftlint:disable:this force_cast
        completion?(viewController)
        return viewController
    }
}

// TODO: - Analyze if this is a good refactor.
//protocol StoryboardInitializable {
//    associatedtype ViewController: UIViewController
//    static func storyboardInit() -> ViewController
//}
//
//extension StoryboardInitializable {
//    static func storyboardInit() -> Self {
//        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
//        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
//            fatalError("Could not instantiate initial viewController of type \(self)")
//        }
//
//        return viewController
//    }
//}
