//
//  ProfileRepository.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import RxSwift

protocol ProfileRepositoryProtocol {
    func fetchUserProfile() -> Single<User>
    func fetchProducts() -> Single<[Product]>
    func fetchAds() -> Single<[Advertisement]>
    func fetchTags() -> Single<[Tag]>
}


class ProfileRepository: BaseRepository, ProfileRepositoryProtocol {
    
    func fetchUserProfile() -> Single<User> {
        return fetch(.getUser, as: User.self)
    }
    
    func fetchProducts() -> Single<[Product]> {
        return fetch(.getProducts, as: [Product].self)
    }
    
    func fetchAds() -> Single<[Advertisement]> {
        return fetch(.getAds, as: [Advertisement].self)
    }
    
    func fetchTags() -> Single<[Tag]> {
        return fetch(.getTags, as: [Tag].self)
    }
}
