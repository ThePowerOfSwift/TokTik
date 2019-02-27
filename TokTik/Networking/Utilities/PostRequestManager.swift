//
//  PostRequestManager.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import Alamofire

protocol PostRequestProtocol {
    func requestPost(postId: Int, completion: @escaping (Data?) -> Void)
}

class PostRequestManager: PostRequestProtocol {

    // Fetch post
    func requestPost(postId: Int, completion: @escaping (Data?) -> Void) {
        AF.request(ContentRouter.postContent(postId: postId))
            .validate()
            .responseData { (response: DataResponse<Data>) in
                completion(response.data)
        }
    }
}
