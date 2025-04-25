//
//  NetworkError.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import Moya

enum NetworkError: Error {
    case server(String)
    case decoding
    case noInternet
    case unknown

    static func map(_ error: Error) -> NetworkError {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response):
                return .server("Server error: \(response.statusCode)")
            case .underlying(let nsError as NSError, _):
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    return .noInternet
                }
                return .server(nsError.localizedDescription)
            case .objectMapping:
                return .decoding
            default:
                return .unknown
            }
        }

        return .unknown
    }
}
