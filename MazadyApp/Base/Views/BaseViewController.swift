//
//  BaseViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    func showSuccess(message: String) {
        SwiftMessagesService.show(message: message, theme: .success)
    }
    
    func showError(message: String) {
        SwiftMessagesService.show(message: message, theme: .error)
    }
}
