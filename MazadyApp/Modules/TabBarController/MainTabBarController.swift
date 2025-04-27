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
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .languageDidChange, object: nil)
    }
    
    // MARK: - Setup Tabs
    private func setupViewControllers() {
        viewControllers = [
            createNavController(for: HomeViewController(), titleKey: "homeTab", imageName: "homeIcon", selectedImageName: "homeSelectedIcon"),
            createNavController(for: SearchViewController(), titleKey: "searchTab", imageName: "searchIcon", selectedImageName: "searchSelectedIcon"),
            createNavController(for: CartViewController(), titleKey: "cartTab", imageName: "cartIcon", selectedImageName: "cartSelectedIcon"),
            createProfileNavController()
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                     titleKey: String,
                                     imageName: String,
                                     selectedImageName: String) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem = UITabBarItem(
            title: titleKey.localized(),
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
            title: "profileTab".localized(),
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
            centerButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -10),
            centerButton.widthAnchor.constraint(equalToConstant: 64),
            centerButton.heightAnchor.constraint(equalToConstant: 64)
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
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.tintColor = .redPrimary
        tabBar.unselectedItemTintColor = UIColor.lightGray
        tabBar.layer.masksToBounds = true
    }
    
    // MARK: - Language Change
    @objc private func languageDidChange() {
        guard let viewControllers = viewControllers else { return }
        
        for (index, vc) in viewControllers.enumerated() {
            switch index {
            case 0:
                vc.tabBarItem.title = "homeTab".localized()
            case 1:
                vc.tabBarItem.title = "searchTab".localized()
            case 2:
                vc.tabBarItem.title = "cartTab".localized()
            case 3:
                vc.tabBarItem.title = "profileTab".localized()
            default:
                break
            }
        }
    }
}
