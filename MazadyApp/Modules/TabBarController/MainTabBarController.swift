//
//  MainTabBarController.swift
//  MazadyApp
//
//  Created by wafaa farrag on 27/04/2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let centerButton = UIButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupCenterButton()
        customizeTabBarAppearance()
        selectedIndex = 3
    }
    
    // MARK: - Setup Tabs
    private func setupViewControllers() {
        viewControllers = [
            createNavController(for: HomeViewController(), title: "Home", imageName: "homeIcon", selectedImageName: "homeSelectedIcon"),
            createNavController(for: SearchViewController(), title: "Search", imageName: "searchIcon", selectedImageName: "searchSelectedIcon"),
            createNavController(for: CartViewController(), title: "Cart", imageName: "cartIcon", selectedImageName: "cartSelectedIcon"),
            createProfileNavController()
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                     title: String,
                                     imageName: String,
                                     selectedImageName: String) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: imageName),
            selectedImage: UIImage(named: selectedImageName)
        )
        
        return navController
    }
    
    private func createProfileNavController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
            fatalError("Failed to instantiate ProfileViewController")
        }
        
        let profileVM = AppDIContainer.shared.makeProfileViewModel()
        profileVC.configure(with: profileVM)
        
        let navController = UINavigationController(rootViewController: profileVC)
        navController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(named: "profileIcon"),
            selectedImage: UIImage(named: "profileSelectedIcon")
        )
        
        return navController
    }
    
    // MARK: - Setup Center Button
    private func setupCenterButton() {
        centerButton.setImage(UIImage(named: "storeIcon"), for: .normal)
        centerButton.tintColor = .white
        centerButton.layer.masksToBounds = true
        
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        
        tabBar.addSubview(centerButton)
        view.layoutIfNeeded()
        
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            centerButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 25),
            centerButton.widthAnchor.constraint(equalToConstant: 44),
            centerButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func centerButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
            menuVC.modalPresentationStyle = .fullScreen
            present(menuVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - TabBar Appearance
    private func customizeTabBarAppearance() {
        tabBar.tintColor = .redPrimary
        tabBar.unselectedItemTintColor = UIColor.lightGray
        tabBar.backgroundColor = .white
        tabBar.layer.masksToBounds = true
    }
}
