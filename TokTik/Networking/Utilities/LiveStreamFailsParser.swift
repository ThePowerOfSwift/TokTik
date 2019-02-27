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

// Sure we could use a third party tool to parse HTMLS (it would also be more reliable), but this looked way to easy to implement
// but anyway this is fiddling with data from a
// website without permission which anyway shouldn't be happening in a real world scenario

class LiveStreamFailsParser {
    
    private struct TitleRegex {
        static let openingTag = "<h4 class=\"post-title\">"
        static let closingTag = "</h4>"
        static let regexPattern = TitleRegex.openingTag + "(.*?)" + TitleRegex.closingTag
    }

    class func getPostTitle(data: Data) -> String?  {
        
        guard let stringData = String(data: data, encoding: .utf8) else {
            return nil
        }
        return LiveStreamFailsParser.getPostTitle(textContent: stringData)
    }
    
    private class func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    class func getPostTitle(textContent: String) -> String?  {
        //Build a regex that finds what's inside of  <h4 class="post-title">...</h4>
        let title = LiveStreamFailsParser.matches(for: TitleRegex.regexPattern, in: textContent).first
        
        //Replace opening and closing tags in the match
        // Note: I'm not sure if this could be improved so the regular expression returns the match without the
        // tags, I haven't played with regex for a bit :P (Also didn't want to spent that much time here)
        return title?.replacingOccurrences(of: TitleRegex.openingTag, with: "").replacingOccurrences(of: TitleRegex.closingTag, with: "")
    }
    
    //<h4 class="post-title">Doc and Peter Stormare forgot to lock the door</h4>
    
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
