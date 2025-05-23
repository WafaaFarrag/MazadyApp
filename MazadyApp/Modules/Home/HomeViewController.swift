//
//  HomeViewController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//
import UIKit

class HomeViewController: UIViewController {

    private let welcomeLabel = UILabel()
    private let imageView = UIImageView()
    private let exploreButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "homeTab".localized()
        setupViews()
    }
    
    private func setupViews() {
        welcomeLabel.text = "welcomeHomeMessage".localized()
        welcomeLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        welcomeLabel.textColor = .redPrimary
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "homeIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        exploreButton.setTitle("exploreMoreButton".localized(), for: .normal)
        exploreButton.setTitleColor(.white, for: .normal)
        exploreButton.backgroundColor = .redPrimary
        exploreButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        exploreButton.layer.cornerRadius = 12
        exploreButton.translatesAutoresizingMaskIntoConstraints = false
        
        exploreButton.addTarget(self, action: #selector(exploreButtonTapped), for: .touchUpInside)
        
        view.addSubview(welcomeLabel)
        view.addSubview(imageView)
        view.addSubview(exploreButton)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            imageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            exploreButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            exploreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exploreButton.widthAnchor.constraint(equalToConstant: 180),
            exploreButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func exploreButtonTapped() {
        let alert = UIAlertController(title: "exploreTitle".localized(), message: "comingSoonMessage".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okButton".localized(), style: .default))
        present(alert, animated: true)
    }
}
