//
//  NewsManager.swift
//  News
//
//  Created by Yuchen Zhong on 2020-02-16.
//  Copyright © 2020 Yuchen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NewsManager {
    typealias NewsLoadState = LoadState<ArticlesResponse>

    enum LoadError: Error {
        case unknownError
    }

    private let client = NewsClient()

    private let timer = Observable<Int>.timer(
        RxTimeInterval.seconds(0),
        period: RxTimeInterval.seconds(120),
        scheduler: ConcurrentDispatchQueueScheduler(qos: .background))

    func news() -> Driver<NewsLoadState> {
        return timer.flatMapLatest { [client] (count) -> Observable<NewsLoadState> in

            let pending: NewsLoadState = (count == 0) ? .loading : .updating

            let loaded: Observable<NewsLoadState> = client.headlines()
                .map({ .loaded(response: $0) })
                .catchError({ Single.just(.failed(error: $0)) })
                .asObservable()

            return Observable.merge([Observable.just(pending), loaded])
        }.asDriver(onErrorJustReturn: .failed(error: LoadError.unknownError))
    }
}
