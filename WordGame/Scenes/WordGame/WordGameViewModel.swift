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
    var shouldEndGame: BehaviorRelay<Bool> {get set}

    func fetchWordPairs()
    func startTimer()
    func evaluateAnswer(answer: Answer)
}

class WordGameViewModel: WordGameViewPresentable {

    // Constants
    enum Constants {
        static let questionsCount = 15
        static let maxIncorrectAttempts = 3
        static let correctnessPercentage = 4
        static let questionTime = 5.0
    }

    // Private variables
    private var model: WordGameModelTransferable?
    private var currentQuestionIndex: Int = .zero
    private var timer: Timer?
    private var disposeBag = DisposeBag()

    // Protocol observables
    var correctCount = BehaviorRelay<Int>(value: .zero)
    var incorrectCount = BehaviorRelay<Int>(value: .zero)
    var currentQuestion = BehaviorRelay<QuestionWord?>(value: nil)
    var shouldEndGame = BehaviorRelay<Bool>(value: false)

    // Computed variables
    private var questions = [QuestionWord]() {
        didSet {
            currentQuestion.accept(questions.first)
        }
    }

    init(model: WordGameModelTransferable = WordGameModel()) {
        self.model = model
    }

    // Protocol functions
    func fetchWordPairs() {
        self.model?.fetchWordPairs().subscribe(onNext: { wordPairs in
            self.questions = self.processQuestions(wordPairs: wordPairs)
        }).disposed(by: self.disposeBag)
    }

    ///Check whether the game should end or not, and start the timer if not
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

    /// Check the enum value coming from the button and increment the attempts counter accordingly
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

    // Private functions
    /// Shuffle the WordPairs provided from the model
    /// And Map it to the struct "QuestionWord" to add whether the pair has the correct translation or not.
    private func processQuestions(wordPairs: [WordPair]) -> [QuestionWord] {
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

    private func incrementCorrectAnswers() {
        if currentQuestionIndex < Constants.questionsCount {
            checkIfLastQuestion()
            correctCount.accept(correctCount.value + 1)
            goToNextQuestion()
        }
    }

   private func incrementIncorrectAnswers() {
        if currentQuestionIndex < Constants.questionsCount {
            checkforNumberOfIncorrect()
            checkIfLastQuestion()
            incorrectCount.accept(incorrectCount.value + 1)
            goToNextQuestion()
        }
    }

    private func checkforNumberOfIncorrect() {
        incorrectCount.subscribe { count in
            if count.element == Constants.maxIncorrectAttempts {
                self.endTheGame()
            }
        }.disposed(by: disposeBag)
    }

    private func checkIfLastQuestion() {
        if currentQuestionIndex < Constants.questionsCount - 1 {
            currentQuestionIndex += 1
        } else {
            self.endTheGame()
        }
    }

    /// Go to next question by setting the observable "currentQuestion"
    private func goToNextQuestion() {
        if currentQuestionIndex < Constants.questionsCount && !shouldEndGame.value {
            currentQuestion.accept(questions[currentQuestionIndex])
            startTimer()
        }
    }

    private func endTheGame() {
        timer?.invalidate()
        self.shouldEndGame.accept(true)
    }

}
