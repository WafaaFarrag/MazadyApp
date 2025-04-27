//
//  Int+Extensions.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import Foundation

extension Int {
    func localizedString() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
