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

    func makeFetchProductsUseCase() -> FetchProductsUseCase {
        return FetchProductsUseCase(repository: makeProfileRepository())
    }

    func makeFetchAdsUseCase() -> FetchAdsUseCase {
        return FetchAdsUseCase(repository: makeProfileRepository())
    }

    func makeFetchTagsUseCase() -> FetchTagsUseCase {
        return FetchTagsUseCase(repository: makeProfileRepository())
    }

    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(
            fetchUserProfileUseCase: makeFetchUserProfileUseCase(),
            fetchProductsUseCase: makeFetchProductsUseCase(),
            fetchAdsUseCase: makeFetchAdsUseCase(),
            fetchTagsUseCase: makeFetchTagsUseCase()
        )
    }
}
