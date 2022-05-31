//
//  WordGameModel.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol WordGameModelTransferable {
    func fetchWordPairs() -> Observable<[WordPair]>
}

class WordGameModel: WordGameModelTransferable {
    var service: WordGameDataFetchable?
    var disposeBag = DisposeBag()

    init(service: WordGameDataFetchable = WordsLoader()) {
        self.service = service
    }

    func fetchWordPairs() -> Observable<[WordPair]> {
        return Observable.create { observer -> Disposable in
            self.service?.fetchWordPairs().subscribe(onNext: { wordPairs in
                observer.onNext(wordPairs)
            }, onError: { error in
                observer.onError(WordGameError(message: error.localizedDescription))
            }).disposed(by: self.disposeBag)
            return Disposables.create {}
        }
    }

}
