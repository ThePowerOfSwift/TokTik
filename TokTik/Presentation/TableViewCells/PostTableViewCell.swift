//
//  PostTableViewCell.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import UIKit
import AVFoundation

protocol PostCellDelegate {
    func reportPostBrokenLink()
    func videoFinishedPlaying()
}


class PostTableViewCell: UITableViewCell {

    @IBOutlet private weak var videoTitle: UILabel!
    
    @IBOutlet private weak var videoContainer: UIView!
    
    private var player: AVPlayer?
    
    private var delegate: PostCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.player = AVPlayer()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(title: String, videoUrl: URL, cellDelegate: PostCellDelegate) {
        
        //let videoUrl = URL(string: "https://stream.livestreamfails.com/video/58999e2d176a2.mp4")!
        //Play video

        //It would be worth considering injecting an instance of a AVPlayerviewcontroller
        // To avoid creating one instance of AVPlayer or AVPlayerviewcontroller (not the current case) per cell
        // -> https://stackoverflow.com/questions/44404053/what-is-the-best-place-to-add-avplayer-or-mpmovieplayercontroller-in-uitableview
        
        self.delegate = cellDelegate
        self.videoTitle.text = title
        
        let videoAsset = AVAsset(url: videoUrl)
        
        if videoAsset.isPlayable {
            // Create an AVPlayerItem with asset
            let videoPlayerItem = AVPlayerItem(asset: videoAsset)
            // Initialize player with the AVPlayerItem instance.
            self.player?.replaceCurrentItem(with: videoPlayerItem)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = self.bounds
            
            self.videoContainer.layer.addSublayer(playerLayer)
            self.videoContainer.backgroundColor = .black
            //Subscribe to notifications to check when video finishes playing
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        } else {
            //A better idea would be to just skip this video
            self.player?.replaceCurrentItem(with: nil)
            self.delegate?.reportPostBrokenLink()
        }
    }
    
    @objc func playerDidFinishPlaying() {
        self.delegate?.videoFinishedPlaying()
    }
    
    func playVideo() {
        self.player?.play()
    }
    
    func stopVideo() {
        self.player?.pause()
        self.player?.replaceCurrentItem(with: nil)
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
    }
}
