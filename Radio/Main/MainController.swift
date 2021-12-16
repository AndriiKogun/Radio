//
//  MainController.swift
//  Radio
//
//  Created by Andrii on 16.12.2021.
//

import UIKit
import SwiftSoup

class MainController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        let htmlFile = Bundle.main.path(forResource: "StationsList", ofType: "html")
        let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)

        do {
           let doc: Document = try SwiftSoup.parse(htmlString!)
                    
           let aaaa = try? doc.text()
            
//            print(aaaa)
            
            let description = try doc.select("[class~=(?i)b-play station_play]").first()!
//            let bbb = try description.select("[class~=(?i)track_history_item]")
            
            let text = description.description
            let nsString = text as NSString

                        
//            let regex = try! NSRegularExpression(pattern: "([^ =,]*)=(\"[^\"]*\"|[^,\"]*)")
//            let result = regex.matches(in:text, range:NSMakeRange(0, text.utf16.count))
                            
        
            let regex = try NSRegularExpression(pattern: "([^ =,]*)=(\"[^\"]*\"|[^,\"]*)")
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
                    
            
            var final = ""
            
            results.forEach { item in
                let text = String(text[Range(item.range, in: text)!]).replacingOccurrences(of: "=", with: ":")
                final.append(text)
                final.append(", ")

            }
            
            final = "{\(final)}"
            
            let array = results.map { item -> String in
                let text = String(text[Range(item.range, in: text)!])
                return text.replacingOccurrences(of: "=", with: ":")
            }

            
//            let array = results.map {
//                String(text[Range($0.range, in: text)!])
//            }
//
//            return results.map {
//                String(text[Range($0.range, in: text)!])
//            }
            
            if let data = final.data(using: .utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:AnyObject]
                    print(json)
                } catch {
                    print("Something went wrong")
                }
            }

            
            print(description)
        
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
            
        }
    
    func matches(for regex: String, in text: String) -> [String] {

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
    
}

