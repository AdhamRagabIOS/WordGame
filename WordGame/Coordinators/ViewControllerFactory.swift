//
//  ViewControllerFactory.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import UIKit

class ViewControllerFactory {
    func createViewController() -> UIViewController {
        let viewController: UIViewController
        viewController = StoryboardScene.Game.wordGameViewController.instantiate().with {
            $0.viewModel = WordGameViewModel()
        }
        return viewController
    }
}
