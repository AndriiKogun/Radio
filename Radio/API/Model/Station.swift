//
//  List.swift
//  Radio
//
//  Created by Andrii on 14.12.2021.
//

import Foundation

struct Station: Decodable {
    var id: String
    var imageUrl: String
    var name: String
    var stream: String
    
    enum CodingKeys : String, CodingKey {
        case id = "radioid"
        case imageUrl = "radioimg"
        case name = "radioname"
        case stream
    }
}

