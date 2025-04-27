//
//  UITextField+Extensions.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//


import UIKit

extension UITextField {
    
    func updateAlignmentForCurrentLanguage() {
        let language = LanguageManager.shared.currentLanguage
        
        if language == .arabic {
            self.semanticContentAttribute = .forceRightToLeft
            self.textAlignment = .right
        } else {
            self.semanticContentAttribute = .forceLeftToRight
            self.textAlignment = .left
        }
    }
    
    func setLocalizedPlaceholder(_ key: String) {
        self.placeholder = key.localized()
        self.updateAlignmentForCurrentLanguage()
    }
}
