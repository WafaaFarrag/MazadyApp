//
//  AppDelegate.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        // Create viewModel
        let profileVM = AppDIContainer.shared.makeProfileViewModel()

        // Load from Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
            fatalError("Could not instantiate ProfileViewController from Storyboard.")
        }

        // Inject ViewModel
        profileVC.configure(with: profileVM)

        // Setup Navigation Controller
        let navVC = UINavigationController(rootViewController: profileVC)

        window.rootViewController = navVC
        window.makeKeyAndVisible()

        return true
    }





}

