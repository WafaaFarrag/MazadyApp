//
//  SwiftMessagesService.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation

import SwiftMessages

class SwiftMessagesService {
    static func show(message: String, theme: Theme = .error) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(theme)
        view.configureContent(title: "", body: message)
        SwiftMessages.show(view: view)
    }
}
