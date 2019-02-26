//
//  ContentRouter.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import Alamofire

enum ContentRouter: APIRouter {
    
    case postContent(postId: Int)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .postContent:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .postContent(let postId):
            return "/post/\(postId)"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .postContent:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let url = try APIConstants.ContentURLs.base.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(self.path))
        
        // HTTP Method
        urlRequest.httpMethod = self.method.rawValue
        
        return urlRequest
    }
}
