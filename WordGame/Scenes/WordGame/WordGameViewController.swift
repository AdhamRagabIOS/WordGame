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

    @IBOutlet private weak var correctLabel: UILabel!
    @IBOutlet private weak var incorrectLabel: UILabel!
    @IBOutlet private weak var englishWordLabel: UILabel!
    @IBOutlet private weak var spanishWordLabel: UILabel!
    @IBOutlet private weak var correctButton: UIButton!
    @IBOutlet private weak var incorrectButton: UIButton!

    var viewModel: WordGameViewPresentable?
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        initilaizeView()
        bindButtonsAnswers()
        bindDataToView()
        fetchWordPairs()
    }

    private func fetchWordPairs() {
        viewModel?.fetchWordPairs()
    }

    private func initilaizeView() {
        correctButton.setTitle(L10n.correct, for: .normal)
        incorrectButton.setTitle(L10n.wrong, for: .normal)
        correctLabel.text = L10n.correctAttempts(.zero)
        incorrectLabel.text = L10n.incorrectAttempts(.zero)
    }

    private func bindButtonsAnswers() {
        Observable.merge(
            correctButton.rx.tap.map { _ in Answer.correct },
            incorrectButton.rx.tap.map { _ in Answer.wrong }
        ).subscribe(onNext: {
            self.viewModel?.evaluateAnswer(answer: $0)
        }).disposed(by: disposeBag)
    }

    private func bindDataToView() {
        setEnglishWord()
        setSpanishWord()
        setCorrectCounter()
        setIncorrectCounter()
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
}
