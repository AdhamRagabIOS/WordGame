//
//  QuestionWord.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import Foundation

struct QuestionWord: Equatable {
    let englishWord: String
    let spanishWord: String
    let isCorrectTranslation: Bool
}

enum Answer: String {
    case correct = "Correct"
    case wrong = "Wrong"
}
