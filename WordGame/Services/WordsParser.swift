//
//  WordsParser.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import Foundation

struct WordsParser {
    func parse(data: Data) throws -> [WordPair] {
        return try JSONDecoder().decode([WordPair].self, from: data)
    }
}
