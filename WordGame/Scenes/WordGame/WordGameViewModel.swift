//
//  WordGameViewModel.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol WordGameViewPresentable {
    var correctCount: BehaviorRelay<Int> { get set }
    var incorrectCount: BehaviorRelay<Int> { get set }
    var currentQuestion: BehaviorRelay<QuestionWord?> { get set }

    func fetchWordPairs()
    func evaluateAnswer(answer: Answer)
}

class WordGameViewModel: WordGameViewPresentable {

    enum Constants {
        static let questionsCount = 15
        static let maxIncorrectAttempts = 10
        static let correctnessPercentage = 4
    }
    var model: WordGameModelTransferable?
    var currentQuestionIndex: Int = .zero
    var correctCount = BehaviorRelay<Int>(value: .zero)
    var incorrectCount = BehaviorRelay<Int>(value: .zero)
    var currentQuestion = BehaviorRelay<QuestionWord?>(value: nil)
    var timer: Timer?
    var disposeBag = DisposeBag()
    var questions = [QuestionWord]() {
        didSet {
            currentQuestion.accept(questions.first)
        }
    }

    init(model: WordGameModelTransferable = WordGameModel()) {
        self.model = model
    }

    func fetchWordPairs() {
        self.model?.fetchWordPairs().subscribe(onNext: { wordPairs in
            self.questions = self.processQuestions(wordPairs: wordPairs)
        }).disposed(by: self.disposeBag)
    }

    private func processQuestions(wordPairs: [WordPair]) -> [QuestionWord] {
        let shufflingPrefix = wordPairs.shuffled().prefix(Constants.questionsCount)
        let numberOfCorrectQuestions = Constants.questionsCount / Constants.correctnessPercentage
        let shuffledQuestions: [QuestionWord] = shufflingPrefix.suffix(
            Constants.questionsCount-numberOfCorrectQuestions
        ).map {
            let spanishTranslations = Set(wordPairs.map { $0.spanish })
            let spanishWord = spanishTranslations.randomElement() ?? $0.spanish
            return QuestionWord(
                englishWord: $0.english,
                spanishWord: spanishWord,
                isCorrectTranslation: spanishWord == $0.spanish)
        }
        let correctQuestions = shufflingPrefix.prefix(numberOfCorrectQuestions).map {
            return QuestionWord(
                englishWord: $0.english,
                spanishWord: $0.spanish,
                isCorrectTranslation: true)
        }
        return (correctQuestions + shuffledQuestions).shuffled()
    }

    func evaluateAnswer(answer: Answer) {
        switch answer {
        case .correct:
            currentQuestion.value?.isCorrectTranslation ?? false
                ?  incrementCorrectAnswers()
                :  incrementIncorrectAnswers()
        case .wrong:
            currentQuestion.value?.isCorrectTranslation ?? false
                ? incrementIncorrectAnswers()
                : incrementCorrectAnswers()
        }
    }

    func incrementCorrectAnswers() {
        if currentQuestionIndex < Constants.questionsCount {
            currentQuestionIndex += 1
            correctCount.accept(correctCount.value + 1)
            goToNextQuestion()
        }
    }

    func incrementIncorrectAnswers() {
        if currentQuestionIndex < Constants.questionsCount {
            currentQuestionIndex += 1
            incorrectCount.accept(incorrectCount.value + 1)
            goToNextQuestion()
        }
    }

    private func goToNextQuestion() {
        if currentQuestionIndex < Constants.questionsCount {
            currentQuestion.accept(questions[currentQuestionIndex])
        }
    }
}
