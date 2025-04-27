//
//  String+Extensions.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

