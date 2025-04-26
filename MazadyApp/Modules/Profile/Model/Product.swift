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
    let image: String
    let price: Double
    let currency: String
    let offer: Double?
    let endDate: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case price
        case currency
        case offer
        case endDate = "end_date"
    }
}
