//
//  FetchUserProfileUseCase.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import RxSwift

protocol FetchUserProfileUseCaseProtocol {
    func execute() -> Single<User>
}

class FetchUserProfileUseCase: BaseUseCase, FetchUserProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> Single<User> {
        return repository.fetchUserProfile()
    }
}
