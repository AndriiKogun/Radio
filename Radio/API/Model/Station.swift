//
//  List.swift
//  Radio
//
//  Created by Andrii on 14.12.2021.
//

import Foundation

//struct StationsModel {
//    var stations = [Station]()
//    var genre = GenreType.
//    
//    
//    var pagesCount: Int
//}

struct Station: Codable {
    
    var id: String
    var radioimg: String
    var name: String
    var stream: String
    var currentTrack: Track?
    var genres: [String]?
    var countryCode: String?
    var renownOrder: Int?
    
    var imageUrl: String {
        return  "https:\(radioimg)"
    }
    
    var title: String {
        if let track = currentTrack {
            return track.trackName
        } else {
            return name
        }
    }
    
    var subtitle: String {
        if let track = currentTrack {
            return track.artistName
        } else {
            return ""
        }
    }

    enum CodingKeys : String, CodingKey {
        case id = "radioid"
        case name = "radioname"
        case radioimg
        case stream
        case genres
        case countryCode
        case renownOrder
    }
}

