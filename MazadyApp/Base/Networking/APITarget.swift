//
//  APITarget.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import Moya

enum APITarget {
    case getUser
    case getProducts
    case getTags
    case getAds
}

extension APITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://stagingapi.mazaady.com/api/interview-tasks")!
    }

    var path: String {
        switch self {
        case .getUser: return "/user"
        case .getProducts: return "/products"
        case .getTags: return "/tags"
        case .getAds: return "/advertisements"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
