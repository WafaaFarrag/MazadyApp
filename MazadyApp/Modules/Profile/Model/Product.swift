//
//  Product.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let price: Double
    let imageURL: String
    let endDate: String?
    let specialLabel: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case imageURL = "image_url"
        case endDate = "end_date"
        case specialLabel = "special_label"
    }
}
