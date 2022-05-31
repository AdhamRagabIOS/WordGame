//
//  WordGameCoordinator.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import UIKit
import HandySwift

/// A coordinator protocol for creating and initializing WordGameViewController.
struct WordGameCoordinator: Coordinator {
    internal var viewControllerFactory: ViewControllerFactory?
    internal var navigationController: UINavigationController?

    init(navigationController: UINavigationController, window: UIWindow, viewControllerFactory: ViewControllerFactory) {
        window.rootViewController = navigationController
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }

    func setViewController() {
        guard let viewController = viewControllerFactory?.createViewController() else { return }
        navigationController?.setViewControllers([viewController], animated: false)
    }
}
