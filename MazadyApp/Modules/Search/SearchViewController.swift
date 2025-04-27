//
//  SearchViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import UIKit


class SearchViewController: UIViewController {

    private let searchBar = UISearchBar()
    private let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "searchTab".localized()
        setupViews()
    }
    
    private func setupViews() {
        searchBar.placeholder = "searchPlaceholderLong".localized()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.text = "startSearchingMessage".localized()
        messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        messageLabel.textColor = .lightGray
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 50)
        ])
    }
}
