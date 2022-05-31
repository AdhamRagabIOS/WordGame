//
//  Coordinator.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import UIKit

/// A coordinator protocol responsible for creating and setting ViewControllers.
protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func setViewController()
}
