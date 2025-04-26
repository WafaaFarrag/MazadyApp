//
//  ProfileViewModel.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwift
import RxCocoa
import RxDataSources

class ProfileViewModel: BaseViewModel {
    private let fetchUserProfileUseCase: FetchUserProfileUseCaseProtocol
    private let fetchProductsUseCase: FetchProductsUseCaseProtocol
    private let fetchAdsUseCase: FetchAdsUseCaseProtocol
    private let fetchTagsUseCase: FetchTagsUseCaseProtocol

    // Output
    let user = BehaviorRelay<User?>(value: nil)
    let products = BehaviorRelay<[Product]>(value: [])
    let ads = BehaviorRelay<[Advertisement]>(value: [])
    let tags = BehaviorRelay<[Tag]>(value: [])
    
    init(fetchUserProfileUseCase: FetchUserProfileUseCaseProtocol,
         fetchProductsUseCase: FetchProductsUseCaseProtocol,
         fetchAdsUseCase: FetchAdsUseCaseProtocol,
         fetchTagsUseCase: FetchTagsUseCaseProtocol) {
        
        self.fetchUserProfileUseCase = fetchUserProfileUseCase
        self.fetchProductsUseCase = fetchProductsUseCase
        self.fetchAdsUseCase = fetchAdsUseCase
        self.fetchTagsUseCase = fetchTagsUseCase
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
    
    func loadProducts() {
        isLoading.accept(true)
        fetchProductsUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                switch result {
                case .success(let products):
                    self?.products.accept(products)
                case .failure(let error):
                    self?.handleError(error as! NetworkError)
                }
                self?.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func searchProducts(by name: String) {
           isLoading.accept(true)
           fetchProductsUseCase.execute(name: name)
               .observe(on: MainScheduler.instance)
               .subscribe { [weak self] result in
                   switch result {
                   case .success(let products):
                       self?.products.accept(products)
                   case .failure(let error):
                       self?.handleError(error as! NetworkError)
                   }
                   self?.isLoading.accept(false)
               }
               .disposed(by: disposeBag)
       }
    
    func loadAds() {
        isLoading.accept(true)
        fetchAdsUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                switch result {
                case .success(let ads):
                    self?.ads.accept(ads)
                case .failure(let error):
                    self?.handleError(error as! NetworkError)
                }
                self?.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func loadTags() {
        isLoading.accept(true)
        fetchTagsUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                switch result {
                case .success(let tags):
                    self?.tags.accept(tags)
                case .failure(let error):
                    self?.handleError(error as! NetworkError)
                }
                self?.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func loadAllData() {
        loadUserProfile()
        loadProducts()
        loadAds()
        loadTags()
    }
}



enum ProfileSectionModel {
    case productsSection(items: [Product])
    case adsSection(items: [Advertisement])
    case tagsSection(items: [Tag])
}

extension ProfileSectionModel: SectionModelType {
    typealias Item = Any
    
    var items: [Any] {
        switch self {
        case .productsSection(let items):
            return items
        case .adsSection(let items):
            return items
        case .tagsSection(let items):
            return items
        }
    }
    
    init(original: ProfileSectionModel, items: [Any]) {
        switch original {
        case .productsSection:
            self = .productsSection(items: items as! [Product])
        case .adsSection:
            self = .adsSection(items: items as! [Advertisement])
        case .tagsSection:
            self = .tagsSection(items: items as! [Tag])
        }
    }
}
