//
//  PostTableViewCell.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import UIKit
import AVFoundation

class PostTableViewCell: UITableViewCell {

    @IBOutlet private weak var videoTitle: UILabel!
    
        @IBOutlet private weak var videoContainer: UIView!
    
    private var player: AVPlayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(title: String, videoUrl: URL) {
        self.videoTitle.text = title
        
        let videoUrl = URL(string: "https://stream.livestreamfails.com/video/5c6da33e290b8.mp4")!
        //Play video
        let videoAsset = AVAsset(url: videoUrl)
        // Create an AVPlayerItem with asset
        let videoPlayerItem = AVPlayerItem(asset: videoAsset)
        
        // Initialize player with the AVPlayerItem instance.
        self.player = AVPlayer(playerItem: videoPlayerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.bounds
        
        self.videoContainer.layer.addSublayer(playerLayer)
    }
    
    func playVideo() {
        self.player.play()
    }
    
    func pauseVideo() {
        self.player.pause()
    }
}
