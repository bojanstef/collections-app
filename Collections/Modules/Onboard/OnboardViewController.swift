//
//  OnboardViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-02.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit

final class OnboardViewController: UIViewController {
    @IBOutlet fileprivate weak var pageContainer: UIView!
    @IBOutlet fileprivate weak var skipButton: UIButton!
    @IBOutlet fileprivate weak var nextButton: ActionButton!
    @IBOutlet fileprivate weak var pageControl: UIPageControl!
    var presenter: OnboardPresentable!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageControl()
        setupNextButton()
        skipButton.setTitleColor(.lightGray, for: .normal)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "pageControllerChildSegue" else {
            log.debug("Segue identifier does not match \(segue.identifier ?? "nil")")
            return
        }

        guard let onboardPageViewController = segue.destination as? OnboardPageViewController else {
            log.debug("Could not cast segue destinate as OnboardPageViewController")
            return
        }

        onboardPageViewController.containerDelegate = self
    }
}

extension OnboardViewController: OnboardPageViewControllerDelegate {
    func didSetupPages(_ pageCount: Int) {
        pageControl.numberOfPages = pageCount
    }

    func didScrollToPage(_ pageIndex: Int) {
        pageControl.currentPage = pageIndex
        if pageIndex == pageControl.numberOfPages - 1 { // Last page
            UIView.animate(withDuration: 1, delay: 20, animations: { [weak self] in
                self?.nextButton.alpha = 1
            }, completion: { [weak self] _ in
                self?.nextButton.isUserInteractionEnabled = true
            })
        }
    }
}

fileprivate extension OnboardViewController {
    func setupPageControl() {
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.5)
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.25)
        pageControl.currentPage = 0
    }

    func setupNextButton() {
        nextButton.setTitle("Continue", for: .normal)
        nextButton.alpha = 0
        nextButton.isUserInteractionEnabled = false
    }

    @IBAction func navigateToAuth() {
        presenter.navigateToAuth()
    }
}

fileprivate extension Selector {
    static let navigateToAuth = #selector(OnboardViewController.navigateToAuth)
}
