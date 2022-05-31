//
//  WordPair.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import Foundation

/// A struct representing the WorPair JSON object.
struct WordPair: Decodable, Equatable {
    let english: String
    let spanish: String

    private enum CodingKeys: String, CodingKey {
        case english = "text_eng"
        case spanish = "text_spa"
    }
}
