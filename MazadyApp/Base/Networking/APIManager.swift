//
//  APIManager.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import Moya
import RxSwift

class APIManager {
    static let shared = APIManager()

    private let provider = MoyaProvider<APITarget>(plugins: [NetworkLoggerPlugin()])

    private init() {}

    func request<T: Decodable>(_ target: APITarget, type: T.Type) -> Single<T> {
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(T.self)
            .catch { error in
                return Single<T>.error(NetworkError.map(error))
            }
    }
}
