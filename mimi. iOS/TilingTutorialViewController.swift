//
//  TilingTutorialViewController.swift
//  mimi. iOS
//
//  Created by Robert on 07.09.19.
//  Copyright © 2019 mimi. All rights reserved.
//

import UIKit
import AVFoundation

class TilingTutorialViewController: UIViewController {

    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playLabel: UILabel!

    private var player: AVPlayer? = nil
    private var playerLayer: AVPlayerLayer? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInset.bottom = 245
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(startVideo))
        playerView.addGestureRecognizer(recognizer)

        guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4")
            else { return }

        self.player = AVPlayer(url: url)
        self.player?.isMuted = true
        let playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.videoGravity = .resizeAspectFill
        self.playerView.layer.addSublayer(playerLayer)

        self.playerLayer = playerLayer
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerLayer?.frame = self.playerView.layer.bounds
    }

    @objc private func startVideo() {
        if player?.timeControlStatus != .playing {
            try? AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try? AVAudioSession.sharedInstance().setActive(true)
            playLabel.isHidden = true
            self.playerView.alpha = 1.0
            player?.play()
        } else {
            playLabel.isHidden = false
            player?.pause()
            self.playerView.alpha = 0.8
        }
    }
}
