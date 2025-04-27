//
//  LanguageManager.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import Foundation

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
        // Post notification or use Rx to notify app
        NotificationCenter.default.post(name: .languageDidChange, object: nil)
    }
}

extension Notification.Name {
    static let languageDidChange = Notification.Name("LanguageDidChangeNotification")
}
