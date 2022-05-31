//
//  WordGameError.swift
//  WordGame
//
//  Created by Adham on 31/05/2022.
//

import Foundation

struct WordGameError: Error {
    var message: String

    init(message: String = "") {
        self.message = message
    }
}
