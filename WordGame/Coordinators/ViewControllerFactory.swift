//
//  ViewControllerFactory.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import UIKit

class ViewControllerFactory {

    /// A ViewController factory that generates ViewControllers on demand.
    /// - Note: Since it is only one ViewController, A ViewController of type WordGameViewController was initialized,
    /// but in the normal case, a generic type of UIViewController should be initialized.
    func createViewController() -> UIViewController {
        let viewController: UIViewController
        viewController = StoryboardScene.Game.wordGameViewController.instantiate().with {
            $0.viewModel = WordGameViewModel()
        }
        return viewController
    }
}
