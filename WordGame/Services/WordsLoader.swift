//
//  WordsLoader.swift
//  WordGame
//
//  Created by Adham Ragab on 29/05/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol WordGameDataFetchable {
    func fetchWordPairs() -> Observable<[WordPair]>
}

/// A struct responsible for fetching the WordPairs.
struct WordsLoader: WordGameDataFetchable {
    func fetchWordPairs() -> Observable<[WordPair]> {
        let fileName = "words.json"
        let parser = WordsParser()

        return Observable.create { observer -> Disposable in
            guard let url = Bundle.main.url(forResource: fileName, withExtension: nil),
                  let data = try? Data(contentsOf: url),
                  let translatedWords = try? parser.parse(data: data) else {
                observer.onError(WordGameError(message: L10n.parsingError))
                return Disposables.create {}
            }
            observer.onNext(translatedWords)
            return Disposables.create {}
        }

    }
}
