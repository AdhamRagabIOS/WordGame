//
//  MockViewModel.swift
//  WordGameTests
//
//  Created by Adham Ragab on 31/05/2022.
//

import Foundation
import RxSwift
import RxCocoa
@testable import WordGame

protocol WordGameViewPresentable {
    var correctCount: BehaviorRelay<Int> { get set }
    var incorrectCount: BehaviorRelay<Int> { get set }
    var currentQuestion: BehaviorRelay<QuestionWord?> { get set }
    var shouldEndGame: BehaviorRelay<Bool> {get set}

    func fetchWordPairs()
    func startTimer()
    func evaluateAnswer(answer: Answer)
}

class MockViewModel: WordGameViewPresentable {

    enum Constants {
        static let questionsCount = 15
        static let maxIncorrectAttempts = 3
        static let correctnessPercentage = 4
        static let questionTime = 5.0
    }

    var model: WordGameModelTransferable?
    var currentQuestionIndex: Int = .zero
    var timer: Timer?
    var disposeBag = DisposeBag()

    var correctCount = BehaviorRelay<Int>(value: .zero)
    var incorrectCount = BehaviorRelay<Int>(value: .zero)
    var currentQuestion = BehaviorRelay<QuestionWord?>(value: nil)
    var shouldEndGame = BehaviorRelay<Bool>(value: false)

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

    func startTimer() {
        if !shouldEndGame.value {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: Constants.questionTime, repeats: false) { _ in
                if self.currentQuestion.value == self.questions[self.currentQuestionIndex] {
                    self.incrementIncorrectAnswers()
                }
            }
        }
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

    func processQuestions(wordPairs: [WordPair]) -> [QuestionWord] {
        let shufflingPrefix = wordPairs.shuffled().prefix(Constants.questionsCount)
        let numberOfCorrectQuestions = Constants.questionsCount / Constants.correctnessPercentage
        let shuffledQuestions: [QuestionWord] = shufflingPrefix.suffix(
            Constants.questionsCount - numberOfCorrectQuestions
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

    func incrementCorrectAnswers() {
        if currentQuestionIndex < Constants.questionsCount {
            checkIfLastQuestion()
            correctCount.accept(correctCount.value + 1)
            goToNextQuestion()
        }
    }

    func incrementIncorrectAnswers() {
        if currentQuestionIndex < Constants.questionsCount {
            checkforNumberOfIncorrect()
            checkIfLastQuestion()
            incorrectCount.accept(incorrectCount.value + 1)
            goToNextQuestion()
        }
    }

    func checkforNumberOfIncorrect() {
        incorrectCount.subscribe { count in
            if count.element == Constants.maxIncorrectAttempts {
                self.endTheGame()
            }
        }.disposed(by: disposeBag)
    }

    func checkIfLastQuestion() {
        if currentQuestionIndex < Constants.questionsCount - 1 {
            currentQuestionIndex += 1
        } else {
            self.endTheGame()
        }
    }

    func goToNextQuestion() {
        if currentQuestionIndex < Constants.questionsCount && !shouldEndGame.value {
            currentQuestion.accept(questions[currentQuestionIndex])
            startTimer()
        }
    }

    func endTheGame() {
        timer?.invalidate()
        self.shouldEndGame.accept(true)
    }

}
