//
//  AppCoordinator.swift
//  MazadyApp
//
//  Created by wafaa farrag on 25/04/2025.
//

import Foundation
import UIKit

class AppCoordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewModel = AppDIContainer.shared.makeProfileViewModel()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
            fatalError("Could not instantiate ProfileViewController from Storyboard.")
        }
        
        viewController.configure(with: viewModel) // Inject ViewModel

        let navController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.navigationController = navController
    }
}
