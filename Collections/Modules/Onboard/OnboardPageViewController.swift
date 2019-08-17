//
//  OnboardPageViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-16.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

protocol OnboardPageViewControllerDelegate: AnyObject {
    func didSetupPages(_ pageCount: Int)
    func didScrollToPage(_ pageIndex: Int)
}

final class OnboardPageViewController: UIPageViewController {
    fileprivate var tutorialViewControllers = [UIViewController]()
    weak var containerDelegate: OnboardPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupViewControllers()
    }
}

extension OnboardPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = tutorialViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0, tutorialViewControllers.count > previousIndex else { return nil }
        return tutorialViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = tutorialViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1

        guard tutorialViewControllers.count != nextIndex, tutorialViewControllers.count > nextIndex else { return nil }
        return tutorialViewControllers[nextIndex]
    }
}

extension OnboardPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
            let currentViewController = pageViewController.viewControllers?.last,
            let viewControllerIndex = tutorialViewControllers.firstIndex(of: currentViewController) else { return }

        containerDelegate?.didScrollToPage(viewControllerIndex)
    }
}

fileprivate extension OnboardPageViewController {
    func setupViewControllers() {
        let tutorialData: [(videoResource: String, descriptionText: String)] = [
            (videoResource: "saveAccount", descriptionText: "Add inspirational accounts to pull content from"),
            (videoResource: "savePhoto", descriptionText: "Search for content based on the date it was posted. Find images to post without searching for hours")
        ]

        tutorialViewControllers = tutorialData.map { data in
            let controller = UIStoryboard.instantiateInitialViewController(OnboardTutorialViewController.self)
            controller.setup(videoResource: data.videoResource, descriptionText: data.descriptionText)
            return controller
        }
        guard let firstVC = tutorialViewControllers.first else { fatalError("Could not load tutorial view controllers.") }
        setViewControllers([firstVC], direction: .forward, animated: true)
        containerDelegate?.didSetupPages(tutorialData.count)
    }
}
