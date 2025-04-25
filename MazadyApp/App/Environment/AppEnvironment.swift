//
//  AppEnvironment.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation

enum AppEnvironment {
    static let current: Environment = .staging

    enum Environment {
        case staging
        case production

        var baseURL: String {
            switch self {
            case .staging: return "https://stagingapi.mazaady.com"
            case .production: return "https://api.mazaady.com"
            }
        }
    }
}
