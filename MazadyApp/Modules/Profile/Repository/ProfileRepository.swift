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
}

class ProfileRepository: BaseRepository, ProfileRepositoryProtocol {
    func fetchUserProfile() -> Single<User> {
        return fetch(.getUser, as: User.self)
    }
}
