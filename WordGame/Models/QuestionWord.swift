//
//  QuestionWord.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import Foundation

/// A struct representing the QuestionWord after decoding and proccessing the WordPair.
struct QuestionWord: Equatable {
    let englishWord: String
    let spanishWord: String
    let isCorrectTranslation: Bool
}

/// An enum representing the type of answer the user will provide and will be passed to the viewModel.
enum Answer: String {
    case correct = "Correct"
    case wrong = "Wrong"
}
