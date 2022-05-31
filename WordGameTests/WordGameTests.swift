//
//  WordGameTests.swift
//  WordGameTests
//
//  Created by Adham Ragab on 28/05/2022.
//

import XCTest
import RxSwift
import RxCocoa

@testable import WordGame

class WordGameTests: XCTestCase {

    var sut: Observable<[WordPair]>?
    var disposeBag = DisposeBag()
    let viewModel = MockViewModel()
    let model = WordGameModel()

    override func setUpWithError() throws {
        let wordLoader = WordsLoader()
        sut = wordLoader.fetchWordPairs()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testWordLoader() throws {
        sut?.subscribe(onNext: { wordPairs in
            XCTAssertEqual(wordPairs.first?.english, "primary school")
        }).disposed(by: disposeBag)
    }

    func testFetchingWordsInModel() throws {
        let model = WordGameModel()
        sut = model.fetchWordPairs()
        sut?.subscribe(onNext: { wordPairs in
            XCTAssertEqual(wordPairs.first?.english, "primary school")
        }).disposed(by: disposeBag)
    }

    func testShufflingQuestionWords() throws {
        sut = model.fetchWordPairs()
        sut?.subscribe(onNext: { wordPairs in
            let questionWords = self.viewModel.processQuestions(wordPairs: wordPairs)
            XCTAssertNotEqual(questionWords.first?.englishWord, "primary school")
        }).disposed(by: disposeBag)
    }

    func testIncrementingCorrectCounter() throws {
        sut = model.fetchWordPairs()
        sut?.subscribe(onNext: { wordPairs in
            self.viewModel.questions = self.viewModel.processQuestions(wordPairs: wordPairs)
            guard let currentQuestion = self.viewModel.questions.first(where: {$0.isCorrectTranslation}) else { return }
            self.viewModel.currentQuestionIndex = self.viewModel.questions.firstIndex(of: currentQuestion) ?? .zero
            self.viewModel.evaluateAnswer(answer: .correct)
            self.viewModel.correctCount.subscribe(onNext: { count in
                XCTAssertEqual(count, 1)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }

    func testIncrementingInCorrectCounter() throws {
        sut = model.fetchWordPairs()
        sut?.subscribe(onNext: { wordPairs in
            self.viewModel.questions = self.viewModel.processQuestions(wordPairs: wordPairs)
            guard let currentQuestion = self.viewModel.questions.first(
                    where: {!$0.isCorrectTranslation}
            ) else { return }
            self.viewModel.currentQuestionIndex = self.viewModel.questions.firstIndex(of: currentQuestion) ?? .zero
            self.viewModel.evaluateAnswer(answer: .correct)
            self.viewModel.incorrectCount.subscribe(onNext: { count in
                XCTAssertEqual(count, 1)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
}
