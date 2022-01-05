//
//  HTMLParser.swift
//  Radio
//
//  Created by Andrii on 27.12.2021.
//

import Foundation
import SwiftSoup

class HTMLParser {
        
    static func getStetions(html: String) -> [Station] {
        var stations = [Station]()

        do {
            let doc: Document = try SwiftSoup.parse(html)
            let list = try doc.select("[class~=(?i)b-play station_play]")
            
            try list.forEach { item in
                let text = try Entities.unescape(item.description)
                let regex = try NSRegularExpression(pattern: "([^ =,]*)=(\"[^\"]*\"|[^,\"]*)", options: [.caseInsensitive])
                let matches  = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
                
                var resultString = ""
                
                try matches.forEach { match in
                    let keyRange =  match.range(at: 1)
                    let valueRange =  match.range(at: 2)
                    
                    if let substringKeyRange = Range(keyRange, in: text), let substringValueRange = Range(valueRange, in: text) {
                        if !resultString.isEmpty {
                            resultString.append(", ")
                        }
                        
                        let key = "\"\(String(text[substringKeyRange]))\""
                        let value = try Entities.unescape(String(text[substringValueRange]))

                        resultString.append(key + ":" + value)
                    }
                }
                
                let jsonString = "{\(resultString)}"
                
                
                guard
                    let data = jsonString.data(using: .utf8),
                    let station = try? JSONDecoder().decode(Station.self, from: data)

                else { return }
                
                
                stations.append(station)
            }
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
        print(stations)
        return stations
    }
}
