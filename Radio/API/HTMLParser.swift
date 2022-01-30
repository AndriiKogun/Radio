//
//  HTMLParser.swift
//  Radio
//
//  Created by Andrii on 27.12.2021.
//

import Foundation
import SwiftSoup

class HTMLParser {
    
    static let shared = HTMLParser()
    var stations = [Station]()
    var countryCode = ""

    func getStetions(html: String) -> [Station] {
        
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let list = try doc.select("[class~=(?i)b-play station_play]")
            let genres = try doc.select("[class~=(?i)stations__station__tags")

            try list.enumerated().forEach { (index, item) in
                if index >= 25 {
                    return
                }
                    
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
                    var station = try? JSONDecoder().decode(Station.self, from: data)
                else { return }
                                                
                if stations.filter({ $0.id == station.id }).isEmpty {
                    if index < genres.count {
                        let genreItem = genres[index]
                        let text = try Entities.unescape(genreItem.description)
                        var genresString = [String]()

                        let p = Pattern.compile("(\"ajax\">(.*?)\\<)")
                        let m: Matcher = p.matcher(in: text)

                        while( m.find() ) {
                            if let group = m.group(2) {
                                let value = try Entities.unescape(group)
                                genresString.append(value)
                            }
                        }
                        station.genres = genresString
                        
                        if countryCode.isEmpty {
                            let p = Pattern.compile("(\"\\/(.*?)\\/)")
                            let m: Matcher = p.matcher(in: text)

                            while( m.find() ) {
                                if let group = m.group(2) {
                                    countryCode = group
                                    
                                    print(group)
                                }
                            }
                        }
                        station.countryCode = countryCode
                    }
                    
                    stations.append(station)
                } else {
//                    print(station.id)
                }
            }
    
            
            print("--------------- added \(stations.count) ")
            stations.forEach { station in
                print("\(station)\n")
            }

            
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
        return stations
    }
    
    func numberOfPages(html: String) -> Int {
        var numberOfPages = 0
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let pagination = try doc.select("[class~=(?i)pagination]")
            if let description = pagination.first()?.description {
                let doc: Document = try SwiftSoup.parse(description)
                let links: Elements = try doc.select("a[href]") // a with href
                
                let text = links.array().description
                                
                let p = Pattern.compile("(\\;p=(.*?)[0-9]+)")
                let m: Matcher = p.matcher(in: text)
                
                while( m.find() ) {
                    let group = m.group()
                    let value = group?.components(separatedBy: "=").last ?? ""
                    
                    if let count = Int(value), count > numberOfPages {
                        numberOfPages = count
                    }
                }
                
                print("--------------try get pages count \(numberOfPages)")
                
                return numberOfPages
            }
        } catch {
            
        }
        return 0
    }
    
    func save() {
        print("--------------try save to JSON")
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let pathWithFileName = documentDirectory.appendingPathComponent("myJsonString.json")
        do {
            let jsonData = try JSONEncoder().encode(stations)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            try jsonString?.write(to: pathWithFileName,
                                  atomically: true,
                                  encoding: .utf8)
        } catch {
            // Handle error
        }
    }
    
    func saveToData() {
        print("--------------try save to DATA")
        
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first {
            let pathWithFileName = documentDirectory.appendingPathComponent("myJsonData")
            do {
                let jsonData = try JSONEncoder().encode(stations)
                let compressedData = try (jsonData as NSData).compressed(using: .lzfse)

                try compressedData.write(to: pathWithFileName)
            } catch {
                // handle error
            }
        }
    }
    
    func readFromFile() -> [Station] {
        guard let pathWithFileName = Bundle.main.path(forResource: "myJsonString", ofType: "json") else { return [] }
        //         let pathWithFileName = try? String(contentsOfFile: path, encoding: .utf8)
        //
        //         guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        //         let pathWithFileName = documentDirectory.appendingPathComponent("myJsonString.json")
        do {
            guard let data = try String(contentsOfFile: pathWithFileName).data(using: .utf8) else { return [] }
            let stations = try JSONDecoder().decode([Station].self, from: data)
            return stations
        } catch {
            print(error)
            return []
        }
    }
    
    func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode([Station].self,
                                                       from: jsonData)
            
            print(decodedData.description)
            print("===================================")
        } catch {
            print("decode error")
        }
    }
}


