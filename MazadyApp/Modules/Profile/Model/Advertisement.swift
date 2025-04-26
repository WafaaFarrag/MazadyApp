//
//  Advertisement.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation

struct AdvertisementsResponse: Codable {
    let advertisements: [Advertisement]
}

struct Advertisement: Codable {
    let id: Int
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image"
    }
}
