//
//  WordGameError.swift
//  WordGame
//
//  Created by Adham Ragab on 31/05/2022.
//

import Foundation

/// A struct representing the Custom WordGame error.
struct WordGameError: Error {
    var message: String

    init(message: String = "") {
        self.message = message
    }
}
