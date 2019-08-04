//
//  OnboardTutorialViewController.swift
//  Collections
//
//  Created by Bojan Stefanovic on 2019-08-02.
//  Copyright © 2019 Bojan Stefanovic. All rights reserved.
//

import UIKit
import AVKit

final class OnboardTutorialViewController: UIViewController {
    @IBOutlet fileprivate weak var previewContainerView: UIView!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    fileprivate var iconImage = UIImage()
    fileprivate var descriptionText = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = descriptionText
    }

    func setup(descriptionText: String) {
        self.descriptionText = descriptionText
    }

    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "saveAccount", ofType:"mp4") else {
            log.debug("Could not load this resource")
            return
        }

        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
}
