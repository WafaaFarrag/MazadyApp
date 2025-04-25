//
//  BaseViewModel.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<String>()
    let disposeBag = DisposeBag()

    func handleError(_ error: NetworkError) {
        SwiftMessagesService.show(message: error.localizedDescription, theme: .error)
    }
}
