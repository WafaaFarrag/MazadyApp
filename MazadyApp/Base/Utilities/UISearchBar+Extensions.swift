//
//  UISearchBar+Extensions.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import UIKit

extension UISearchBar {
    
    func updateAlignmentForCurrentLanguage() {
        guard let textField = self.value(forKey: "searchField") as? UITextField else { return }
        
        let language = LanguageManager.shared.currentLanguage
        
        if language == .arabic {
            textField.semanticContentAttribute = .forceRightToLeft
            textField.textAlignment = .right
        } else {
            textField.semanticContentAttribute = .forceLeftToRight
            textField.textAlignment = .left
        }
    }
    
    func setLocalizedPlaceholder(_ key: String) {
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.placeholder = key.localized()
            updateAlignmentForCurrentLanguage()
        }
    }
}
