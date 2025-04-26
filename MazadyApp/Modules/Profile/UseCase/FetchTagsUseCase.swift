//
//  FetchTagsUseCase.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import Foundation
import RxSwift

protocol FetchTagsUseCaseProtocol {
    func execute() -> Single<[Tag]>
}

class FetchTagsUseCase: BaseUseCase, FetchTagsUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> Single<[Tag]> {
        return repository.fetchTags()
    }
}
