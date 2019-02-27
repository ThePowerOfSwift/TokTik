//
//  VideoPostsTableViewController.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import UIKit

class VideoPostsTableViewController: UITableViewController, UIMessageProtocol, UIActivityHUD {
    
    var postController: PostModelController!
    
    private var currentDisplayIndex = 0
    
    private struct CellId {
        static let postCellId = "PostTableViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.addGestureRecognizers() 
        self.loadPosts(completion: nil)
        
        //Subscribe to notifications to check when video finishes playing
        //This code was originally in the cell (better encapsulation - and it seems more logical so the parent does not now what his child is up to) but adding observer in cells could have some potential issues (not being released, and they're reused)
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayNextVideo(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadPosts(completion: (() -> ())?) {
        self.showHUD(status: "Loading posts")
        self.postController.getPosts(completion: { success in
            self.hideHUD()
            if success {
                self.tableView.reloadData()
            } else {
                self.showMessage(title: "Oups", message: "Could not fetch posts", type: .error)
            }
            completion?()
        })
    }
    
    func addGestureRecognizers() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(displayNextVideo))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(displayPreviousVideo))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func displayNewCellAtIndex(_ newIndex: Int) {
        self.currentDisplayIndex = newIndex
        let newIndexPath = IndexPath(row: self.currentDisplayIndex, section: 0)
        self.tableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
    }
    
    @IBAction func displayNextVideo(_ sender: Any) {
        let nextIndex = self.currentDisplayIndex + 1
        if nextIndex < self.postController.postsCount() {
            self.displayNewCellAtIndex(nextIndex)
        } else {
            self.loadPosts(completion: {
                self.displayNextVideo(self)
            })
        }
    }
    
    @IBAction func displayPreviousVideo(_ sender: Any) {
        let nextIndex = self.currentDisplayIndex - 1
        if nextIndex >= 0 {
            self.displayNewCellAtIndex(nextIndex)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Table view data source

extension VideoPostsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postController.postsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.postCellId, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let post = self.postController.post(at: indexPath.row)
        cell.setup(title: post.title, videoUrl: post.videoURL, cellDelegate: self)
        
        return cell
    }
}

 // MARK: - Table view delegate

extension VideoPostsTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.bounds.size.height
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let postCell = cell as? PostTableViewCell else { return }
        postCell.playVideo()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let postCell = cell as? PostTableViewCell else { return }
        postCell.stopVideo()
    }

}

extension VideoPostsTableViewController: PostCellDelegate {
    
    func reportPostBrokenLink() {
        self.showMessage(title: "Oups", message: "This video link seems broken :(", type: .error)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.displayNextVideo(self)
        })
    }
    
    func videoFinishedPlaying() {
        self.displayNextVideo(self)
    }
}
