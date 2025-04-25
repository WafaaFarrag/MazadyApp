//
//  ProfileViewModel.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: BaseViewModel {
    private let fetchUserProfileUseCase: FetchUserProfileUseCaseProtocol
    
    // Output
    let user = BehaviorRelay<User?>(value: nil)

    init(fetchUserProfileUseCase: FetchUserProfileUseCaseProtocol) {
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        super.init()
    }
    
    func loadUserProfile() {
        isLoading.accept(true)
        fetchUserProfileUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                switch result {
                case .success(let user):
                    self?.user.accept(user)
                case .failure(let error):
                    self?.handleError(error as! NetworkError)
                }
                self?.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
