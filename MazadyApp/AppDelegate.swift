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

        // Setup MainTabBarController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {
            fatalError("Could not instantiate MainTabBarController from Storyboard.")
        }
        
        window.rootViewController = mainTabBarController
        window.makeKeyAndVisible()

        return true
    }






}

