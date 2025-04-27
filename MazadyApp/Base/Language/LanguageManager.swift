//
//  LanguageManager.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import Foundation
import UIKit

class LanguageManager {

    static let shared = LanguageManager()
    private init() {}

    private let selectedLanguageKey = "SelectedLanguage"

    enum Language: String {
        case english = "en"
        case arabic = "ar"
    }

    var currentLanguage: Language {
        get {
            let saved = UserDefaults.standard.string(forKey: selectedLanguageKey) ?? Language.english.rawValue
            return Language(rawValue: saved) ?? .english
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: selectedLanguageKey)
        }
    }


    func setLanguage(_ language: Language) {
        currentLanguage = language
        
        UserDefaults.standard.setValue(language.rawValue, forKey: selectedLanguageKey)
        
        if language == .arabic {
            Bundle.setLanguage("ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            Bundle.setLanguage("en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        NotificationCenter.default.post(name: .languageDidChange, object: nil)
    }
    
    func applyCurrentLanguageSettings() {
        let language = currentLanguage
        Bundle.setLanguage(language.rawValue)
        
        if language == .arabic {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }


}

extension Notification.Name {
    static let languageDidChange = Notification.Name("LanguageDidChangeNotification")
}
