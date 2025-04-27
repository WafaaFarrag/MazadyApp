//
//  LanguageSelectionViewModel.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import Foundation
import RxSwift
import RxCocoa

class LanguageSelectionViewModel: BaseViewModel {

    let languagesRelay = BehaviorRelay<[String]>(value: ["English", "العربية"])
    let filteredLanguagesRelay = BehaviorRelay<[String]>(value: ["English", "العربية"])
    let selectedLanguageRelay: BehaviorRelay<String?>

    override init() {
        let currentLanguage = LanguageManager.shared.currentLanguage
        let selectedLanguageName: String
        switch currentLanguage {
        case .english:
            selectedLanguageName = "English"
        case .arabic:
            selectedLanguageName = "العربية"
        }
        
        selectedLanguageRelay = BehaviorRelay<String?>(value: selectedLanguageName)

        super.init()
    }

    func filterLanguages(searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filteredLanguagesRelay.accept(languagesRelay.value)
        } else {
            let filtered = languagesRelay.value.filter { $0.localizedCaseInsensitiveContains(searchText) }
            filteredLanguagesRelay.accept(filtered)
        }
    }

    func selectLanguage(at index: Int) {
        guard index < filteredLanguagesRelay.value.count else { return }
        let selected = filteredLanguagesRelay.value[index]
        selectedLanguageRelay.accept(selected)

        if selected == "English" {
            LanguageManager.shared.setLanguage(.english)
        } else if selected == "العربية" {
            LanguageManager.shared.setLanguage(.arabic)
        }
    }

    func language(at index: Int) -> String {
        return filteredLanguagesRelay.value[index]
    }

    func isSelected(at index: Int) -> Bool {
        return filteredLanguagesRelay.value[index] == selectedLanguageRelay.value
    }

    var languagesCount: Int {
        return filteredLanguagesRelay.value.count
    }
    
    func cellViewModel(at index: Int) -> LanguageCellViewModel {
        let title = filteredLanguagesRelay.value[index]
        let isSelected = (title == selectedLanguageRelay.value)
        return LanguageCellViewModel(title: title, isSelected: isSelected)
    }

}

