//
//  WordGameViewController.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class WordGameViewController: UIViewController {

    // Constants
    enum Constants {
        static let closingTime = 5.0
    }

    // IBOutlets
    @IBOutlet private weak var correctLabel: UILabel!
    @IBOutlet private weak var incorrectLabel: UILabel!
    @IBOutlet private weak var englishWordLabel: UILabel!
    @IBOutlet private weak var spanishWordLabel: UILabel!
    @IBOutlet private weak var correctButton: UIButton!
    @IBOutlet private weak var incorrectButton: UIButton!

    // Protocol variables
    var viewModel: WordGameViewPresentable?

    // Private variables
    private var disposeBag = DisposeBag()

    // ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initilaizeView()
        bindButtonsAnswers()
        bindDataToView()
        fetchWordPairs()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }

    // Private functions
    private func fetchWordPairs() {
        viewModel?.fetchWordPairs()
    }

    private func startTimer() {
        viewModel?.startTimer()
    }

    private func initilaizeView() {
        correctButton.setTitle(L10n.correct, for: .normal)
        correctButton.layer.borderWidth = 1
        correctButton.layer.borderColor = UIColor.black.cgColor
        correctLabel.text = L10n.correctAttempts(.zero)
        incorrectButton.setTitle(L10n.wrong, for: .normal)
        incorrectButton.layer.borderWidth = 1
        incorrectButton.layer.borderColor = UIColor.black.cgColor
        incorrectLabel.text = L10n.incorrectAttempts(.zero)
    }

    /// Listen to Answer buttons and bind it to the Answer enum.
    private func bindButtonsAnswers() {
        Observable.merge(
            correctButton.rx.tap.map { _ in Answer.correct },
            incorrectButton.rx.tap.map { _ in Answer.wrong }
        ).subscribe(onNext: {
            self.viewModel?.evaluateAnswer(answer: $0)
        }).disposed(by: disposeBag)
    }

    /// Add all bindings and observables.
    private func bindDataToView() {
        setEnglishWord()
        setSpanishWord()
        setCorrectCounter()
        setIncorrectCounter()
        binEndingGame()
    }

    private func setEnglishWord() {
        viewModel?.currentQuestion.subscribe(onNext: { questionWord in
            self.englishWordLabel.text = questionWord?.englishWord
        }).disposed(by: disposeBag)
    }

    private func setSpanishWord() {
        viewModel?.currentQuestion.subscribe(onNext: { questionWord in
            self.spanishWordLabel.text = questionWord?.spanishWord
        }).disposed(by: disposeBag)
    }

    private func setCorrectCounter() {
        viewModel?.correctCount.subscribe(onNext: { count in
            self.correctLabel.text = L10n.correctAttempts(count)
        }).disposed(by: disposeBag)
    }

    private func setIncorrectCounter() {
        viewModel?.incorrectCount.subscribe(onNext: { count in
            self.incorrectLabel.text = L10n.incorrectAttempts(count)
        }).disposed(by: disposeBag)
    }

    private func binEndingGame() {
        viewModel?.shouldEndGame.subscribe(onNext: { shouldEndGame in
            if shouldEndGame {
                self.closeTheApp()
            }
        }).disposed(by: disposeBag)
    }

    /// Show alert to inform that the game ended and the app will close.
    private func closeTheApp() {
        let alert = UIAlertController(
            title: L10n.gameOver,
            message: L10n.theAppWillCloseTheApp,
            preferredStyle: UIAlertController.Style.alert
        )
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.closingTime) {
                exit(-1)
            }
        }
    }
}
