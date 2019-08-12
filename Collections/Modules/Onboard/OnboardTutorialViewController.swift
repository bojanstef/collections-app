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
    fileprivate var videoResource = String()
    fileprivate var descriptionText = String()
    fileprivate var player = AVPlayer()
    fileprivate var playerLayer = AVPlayerLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = descriptionText
        playVideo(resource: videoResource)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = previewContainerView.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: .videoEnded, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        playerLayer.frame = previewContainerView.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    func setup(videoResource: String, descriptionText: String) {
        self.videoResource = videoResource
        self.descriptionText = descriptionText
    }
}

fileprivate extension OnboardTutorialViewController {
    func playVideo(resource videoResource: String) {
        guard let path = Bundle.main.path(forResource: videoResource, ofType: "mp4") else {
            log.debug("Could not load resource \(videoResource)")
            return
        }

        let videoURL = URL(fileURLWithPath: path)
        player = AVPlayer(url: videoURL)

        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.needsDisplayOnBoundsChange = true
        previewContainerView.layer.insertSublayer(playerLayer, at: 0)
        player.play()
    }

    @objc func videoEnded() {
        player.seek(to: .zero)
        player.play()
    }
}

fileprivate extension Selector {
    static let videoEnded = #selector(OnboardTutorialViewController.videoEnded)
}
