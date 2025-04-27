//
//  FollowersViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import Foundation
import UIKit

class FollowersViewController: UIViewController {
    
    private let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Followers"
        
        setupViews()
    }
    
    private func setupViews() {
        messageLabel.text = "No followers yet!"
        messageLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        messageLabel.textColor = .lightGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
