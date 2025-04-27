
//
//  NetworkError.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import Foundation
import Moya

enum NetworkError: Error, LocalizedError {
    case server(String)      // Backend server error
    case decoding             // Mapping error
    case noInternet           // No internet
    case timeout              // Request timeout
    case cancelled            // Request was cancelled
    case unknown              // Unknown error

    static func map(_ error: Error) -> NetworkError {

        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response):
                return .server("Server error: \(response.statusCode)")

            case .underlying(let nsError as NSError, _):
                switch nsError.code {
                case NSURLErrorNotConnectedToInternet:
                    return .noInternet
                case NSURLErrorTimedOut:
                    return .timeout
                case NSURLErrorCancelled:
                    return .cancelled
                default:
                    return .server(nsError.localizedDescription)
                }

            case .objectMapping:
                return .decoding

            default:
                return .unknown
            }
        }

        let nsError = error as NSError
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            return .noInternet
        case NSURLErrorTimedOut:
            return .timeout
        case NSURLErrorCancelled:
            return .cancelled
        default:
            break
        }

        if !ReachabilityManager.shared.isConnected {
            return .noInternet
        }

        // 4. Fallback
        return .unknown
    }


    // MARK: - LocalizedError
    var errorDescription: String? {
        switch self {
        case .server(let message):
            return message
        case .decoding:
            return NSLocalizedString("errorDecoding", comment: "Decoding error")
        case .noInternet:
            return NSLocalizedString("errorNoInternet", comment: "No internet connection")
        case .timeout:
            return NSLocalizedString("errorTimeout", comment: "Request timeout")
        case .cancelled:
            return NSLocalizedString("errorCancelled", comment: "Request cancelled")
        case .unknown:
            return NSLocalizedString("errorUnknown", comment: "Unknown error")
        }
    }
}
