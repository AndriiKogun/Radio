//
//  List.swift
//  Radio
//
//  Created by Andrii on 14.12.2021.
//

import Foundation

struct List: Decodable {
    let devices: [Devices]

    enum CodingKeys : String, CodingKey {
        case devices = "user_devices"
    }
}


struct Devices: Decodable {
    let name: String

    enum CodingKeys : String, CodingKey {
        case name = "device_name"
    }
}
