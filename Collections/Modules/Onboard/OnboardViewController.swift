//
//  OnboardViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-02.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class OnboardViewController: UIPageViewController {
    fileprivate var tutorialViewControllers = [UIViewController]()
    fileprivate var pageControl = UIPageControl()
    fileprivate var nextButton = ActionButton(type: .system)
    var presenter: OnboardPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = .white
        title = "Collections"
        setupViewControllers()
        setupPageControl()
        setupNextButton()
    }
}

extension OnboardViewController: UIPageViewControllerDataSource {
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

extension OnboardViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
            let currentViewController = pageViewController.viewControllers?.last,
            let viewControllerIndex = tutorialViewControllers.firstIndex(of: currentViewController) else { return }

        pageControl.currentPage = viewControllerIndex

        if viewControllerIndex == pageControl.numberOfPages - 1 { // Last page
            UIView.animate(withDuration: 1, delay: 20, animations: { [weak self] in
                self?.nextButton.alpha = 1
            }, completion: { [weak self] _ in
                self?.nextButton.isUserInteractionEnabled = true
            })
            nextButton.addTarget(self, action: .navigateToAuth, for: .touchUpInside)
        }
    }
}

fileprivate extension OnboardViewController {
    func setupViewControllers() {
        let tutorialData: [(videoResource: String, descriptionText: String)] = [
            (videoResource: "saveAccount", descriptionText: "Add accounts in your niche to get content from"),
            (videoResource: "savePhoto", descriptionText: "Search for content based on the date it was posted. Find images to post without searching for hours")
        ]

        tutorialViewControllers = tutorialData.map { data in
            let controller = UIStoryboard.instantiateInitialViewController(OnboardTutorialViewController.self)
            controller.setup(videoResource: data.videoResource, descriptionText: data.descriptionText)
            return controller
        }
        guard let firstVC = tutorialViewControllers.first else { fatalError("Could not load tutorial view controllers.") }
        setViewControllers([firstVC], direction: .forward, animated: true)
    }

    func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.5)
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.25)
        pageControl.currentPage = 1
        pageControl.numberOfPages = tutorialViewControllers.count

        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)

        let bottomAnchor = pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
        let centerXAnchor = pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([bottomAnchor, centerXAnchor])
    }

    func setupNextButton() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Continue", for: .normal)
        nextButton.alpha = 0
        nextButton.isUserInteractionEnabled = false
        view.addSubview(nextButton)
        view.bringSubviewToFront(nextButton)

        let heightAnchor = nextButton.heightAnchor.constraint(equalToConstant: 44)
        let leadingAnchor = nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32)
        let trailingAnchor = nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        let bottomAnchor = nextButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -16)
        let centerXAnchor = nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([heightAnchor, leadingAnchor, trailingAnchor, bottomAnchor, centerXAnchor])
    }

    @objc func navigateToAuth() {
        presenter.navigateToAuth()
    }
}

fileprivate extension Selector {
    static let navigateToAuth = #selector(OnboardViewController.navigateToAuth)
}
