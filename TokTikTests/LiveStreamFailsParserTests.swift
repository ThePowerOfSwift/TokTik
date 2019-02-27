//
//  LiveStreamFailsParserTests.swift
//  TokTikTests
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import XCTest

class LiveStreamFailsParserTests: XCTestCase {
    
    var parserText: String!

    override func setUp() {
        super.setUp()
        
        guard let filePath = Bundle.main.path(forResource: "Post4821", ofType: "html") else {
            print("LiveStreamParserTests Error: Could not locate the file resource with parser data")
            fatalError()
        }
        
        do {
            let fileContent = try String(contentsOfFile: filePath)
            self.parserText = fileContent
        } catch {
            print("Error: Could not load file content")
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMP4LinkParser() {
        let videoUrls = LiveStreamFailsParser.getPostVideoURL(textContent: self.parserText, videoFormat: .mp4)
        //Check non nil and at that there is at least one value
        XCTAssertNotNil(videoUrls)
        XCTAssertNotNil(videoUrls?.first)
    }

    func testPostTitleParser() {
        let expectedPostTitle = "Doc and Peter Stormare forgot to lock the door"
        let title = LiveStreamFailsParser.getPostTitle(textContent: self.parserText)
        XCTAssertNotNil(title)
        XCTAssertEqual(expectedPostTitle, title)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
