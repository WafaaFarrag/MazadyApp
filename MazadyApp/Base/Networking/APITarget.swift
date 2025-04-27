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
    case searchProducts(name: String)
}

extension APITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://stagingapi.mazaady.com/api/interview-tasks")!
    }

    var path: String {
        switch self {
        case .getUser: return "/user"
        case .getProducts, .searchProducts: return "/products"
        case .getTags: return "/tags"
        case .getAds: return "/advertisements"
            
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .searchProducts(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        let localeValue: String
        switch LanguageManager.shared.currentLanguage {
        case .arabic:
            localeValue = "ar"
        case .english:
            localeValue = "en"
        }

        return [
            "Content-Type": "application/json",
            "Accept-Language": localeValue,
            "locale": localeValue
        ]
    }

}
