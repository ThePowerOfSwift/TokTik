//
//  ContentRouterTests.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import XCTest
import Alamofire
@testable import TokTik

class ContentReouterTests: XCTestCase {
    
    var postRequestManager: PostRequestProtocol!
    
    override func setUp() {
        super.setUp()
        self.postRequestManager = PostRequestManager()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Test Content Request succeeds - Server is reachable
    func testContentRequest() {
        
        let ex = expectation(description: "Expecting a response")
        
        let postContentId = 200
        
        self.postRequestManager.requestPost(postId: postContentId, completion: { data in
            XCTAssertNotNil(data)
            ex.fulfill()
        })

        waitForExpectations(timeout: 15) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
