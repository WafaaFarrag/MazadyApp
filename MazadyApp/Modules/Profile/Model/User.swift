//
//  User.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let email: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case profileImage = "profile_image"
    }
}
