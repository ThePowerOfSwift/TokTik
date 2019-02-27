//
//  PostModelController.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import Alamofire

protocol PostControllerProtocol {
    func postsCount() -> Int
    func getPosts(completion: @escaping (Bool) -> Void)
    func post(at index: Int) -> Post
}

class PostModelController {

    private var posts: [Post] = []
    
    private var currentPostId: Int
    
    private let idRandomUpperLimit = 500
    
    private let idRandomLowerLimit = 1
    
    private static let postsRefillThreshold = 3
    
    private let requestManager: PostRequestProtocol
    
    init(postRequestManager: PostRequestProtocol) {
        self.currentPostId =  Int.random(in: self.idRandomLowerLimit ... self.idRandomUpperLimit)
        self.requestManager = postRequestManager
    }
    
    private func addNewPosts(amount: Int, completion: @escaping (Bool) -> Void) {
        var postReceived = 0
  
        for _ in 0..<amount {
            self.requestManager.requestPost(postId: self.currentPostId, completion: { data in
                //Process and create post
                guard let data = data, let title = LiveStreamFailsParser.getPostTitle(data: data),
                    let videoUrl = LiveStreamFailsParser.getPostVideoURL(data: data, videoFormat: .mp4)?.first else {
                        return
                }
                self.posts.append(Post(videoURL: videoUrl, title: title))
                //Notify if ready
                postReceived += 1
                if postReceived == amount {
                    completion(true)
                }
            })
        }
    }
}

// MARK: - PostControllerProtocol implementation

extension PostModelController: PostControllerProtocol {
    
    func postsCount() -> Int {
        return self.posts.count
    }
    
    func getPosts(completion: @escaping (Bool) -> Void) {
        self.addNewPosts(amount: PostModelController.postsRefillThreshold, completion: { success in
            completion(success)
        })
    }
    
    func post(at index: Int) -> Post {
        return self.posts[index]
    }
}
