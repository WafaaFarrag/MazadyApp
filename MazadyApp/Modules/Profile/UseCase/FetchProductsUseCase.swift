//
//  FetchProductsUseCase.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import Foundation
import RxSwift

protocol FetchProductsUseCaseProtocol {
    func execute() -> Single<[Product]>
}

class FetchProductsUseCase: BaseUseCase, FetchProductsUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> Single<[Product]> {
        return repository.fetchProducts()
    }
}
