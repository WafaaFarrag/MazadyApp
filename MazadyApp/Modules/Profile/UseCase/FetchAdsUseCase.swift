//
//  FetchAdsUseCase.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import Foundation
import RxSwift

protocol FetchAdsUseCaseProtocol {
    func execute() -> Single<[Advertisement]>
}

class FetchAdsUseCase: BaseUseCase, FetchAdsUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> Single<[Advertisement]> {
        return repository.fetchAds()
    }
}
