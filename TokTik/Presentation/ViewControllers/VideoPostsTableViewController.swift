//
//  VideoPostsTableViewController.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import UIKit

class VideoPostsTableViewController: UITableViewController, UIMessageProtocol {
    
    var postController: PostModelController!
    
    private struct CellId {
        static let postCellId = "PostTableViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postController.getPosts(completion: { success in
            if success {
                self.showMessage(title: "Nice", message: "everything works", type: .success)
            } else {
                self.showMessage(title: "Oups", message: "Could not fetch posts", type: .error)
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.postCellId, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        

        return cell
    }
    
}
