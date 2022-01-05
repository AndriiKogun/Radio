//
//  Track.swift
//  Radio
//
//  Created by Andrii on 28.12.2021.
//

import Foundation

struct Track: Decodable {
    var id: Int
    var alias: String
    var updated: Double
    var title: String
    
    enum CodingKeys : String, CodingKey {
        case id = "stationId"
        case alias
        case updated
        case title
    }
    
    var trackName: String {
        let items = title.components(separatedBy: " - ")
        return items.last ?? ""
    }
    
    var artistName: String {
        let items = title.components(separatedBy: " - ")
        return items.first ?? ""
    }
    
    var updatedDate: Date {
        return Date(timeIntervalSince1970: updated)
    }
}
