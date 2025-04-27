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

        setupRootViewController()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(languageDidChange),
            name: .languageDidChange,
            object: nil
        )

        return true
    }

    @objc private func languageDidChange() {
        setupRootViewController()
    }

    private func setupRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {
            fatalError("Could not instantiate MainTabBarController from Storyboard.")
        }

        UIView.transition(with: window!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                              self.window?.rootViewController = mainTabBarController
                          },
                          completion: nil)
    }
}

