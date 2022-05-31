//
//  SceneDelegate.swift
//  WordGame
//
//  Created by Adham Ragab on 28/05/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        window.makeKeyAndVisible()
        self.window = window
        let viewControllerFactory = ViewControllerFactory()
        let coordinator: Coordinator = WordGameCoordinator(
            navigationController: navigationController,
            window: self.window ?? UIWindow(),
            viewControllerFactory: viewControllerFactory
        )
        coordinator.setViewController()
    }
}
