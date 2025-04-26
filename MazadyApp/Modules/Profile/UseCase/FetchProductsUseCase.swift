//
//  FetchProductsUseCase.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import Foundation
import RxSwift

protocol FetchProductsUseCaseProtocol {
    func execute(name: String) -> Single<[Product]>
    func execute() -> Single<[Product]>
}

class FetchProductsUseCase: BaseUseCase, FetchProductsUseCaseProtocol {
 
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(name: String) -> Single<[Product]> {
        return repository.fetchProducts(name: name)
    }
    
    func execute() -> RxSwift.Single<[Product]> {
        return repository.fetchProducts()
    }
}
