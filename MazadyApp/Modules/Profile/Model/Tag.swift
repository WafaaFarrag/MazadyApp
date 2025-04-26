//
//  Tag.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation

struct TagsResponse: Codable {
    let tags: [Tag]
}

struct Tag: Codable {
    let id: Int
    let name: String
}
