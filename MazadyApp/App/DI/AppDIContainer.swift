//
//  AppDIContainer.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation

final class AppDIContainer {
    static let shared = AppDIContainer()

    private init() {}

    func makeProfileRepository() -> ProfileRepositoryProtocol {
        return ProfileRepository()
    }

    func makeFetchUserProfileUseCase() -> FetchUserProfileUseCase {
        return FetchUserProfileUseCase(repository: makeProfileRepository())
    }

    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(fetchUserProfileUseCase: makeFetchUserProfileUseCase())
    }
}
