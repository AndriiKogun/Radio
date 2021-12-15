//
//  LoginModel.swift
//  Radio
//
//  Created by Andrii on 14.12.2021.
//

import Foundation

struct LoginModel: Decodable {
    let role: String
    let groupID: Int

    enum CodingKeys : String, CodingKey {
        case role = "user_role"
        case groupID = "root_group_id"
    }
}
