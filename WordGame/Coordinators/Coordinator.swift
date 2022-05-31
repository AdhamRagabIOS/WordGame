//
//  Coordinator.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func setViewController()
}
