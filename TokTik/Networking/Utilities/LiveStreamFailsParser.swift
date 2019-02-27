//
//  LiveStreamFailsParser.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import Foundation

enum VideoFormat: String {
    // This data structure could be useful if we needed support for different video formats
    case mp4 = "mp4"
}

class LiveStreamFailsParser {

    class func getPostTitle(data: Data) -> String?  {
        return nil
    }
    
    class func getPostVideoURL(textContent: String, videoFormat: VideoFormat) -> Set<URL>? {
        
        //Create a detector to parse links
        let linkTypes: NSTextCheckingResult.CheckingType = .link
        
        guard let detector = try? NSDataDetector(types: linkTypes.rawValue) else {
            return nil
        }
        
        //Get matches
        let matches = detector.matches(in: textContent, options: .reportCompletion, range: NSMakeRange(0, textContent.count))
        
        var linkSet: Set<URL> = []
        
        //Place them in a set to avoid repeated values
        for match in matches {
            if let matchURL = match.url, matchURL.absoluteString.contains(videoFormat.rawValue) == true {
                linkSet.insert(matchURL)
            }
        }
        
        return linkSet
    }
    
    class func getPostVideoURL(data: Data, videoFormat: VideoFormat) -> Set<URL>? {
        
        guard let stringData = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return LiveStreamFailsParser.getPostVideoURL(textContent: stringData, videoFormat: videoFormat)
    }
}
