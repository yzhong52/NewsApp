//
//  NewsClient.swift
//  News
//
//  Created by Yuchen Zhong on 2020-02-16.
//  Copyright © 2020 Yuchen. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

// TODO: update the API key
private let apiKey: String = "c8707b3709a34bbe90837f63c71537ed"
private let path: String = "https://newsapi.org/v2/top-headlines?apiKey=\(apiKey)&country=us"

enum ClientError: Error {
    case missingResponseData
}

class NewsClient {
    func headlines() -> Single<ArticlesResponse> {
        return Single.create { (emitter) -> Disposable in
            let session = Alamofire.Session()
            session.request(path).responseJSON { (response) in
                if let error = response.error {
                    emitter(.error(error))
                    return
                }
                guard let data = response.data else {
                    emitter(.error(ClientError.missingResponseData))
                    return
                }
                do {
                    let articles = try JSONDecoder().decode(
                        ArticlesResponse.self,
                        from: data)
                    emitter(.success(articles))
                } catch {
                    emitter(.error(error))
                }
            }
            return Disposables.create {
                session.cancelAllRequests()
            }
        }
    }
}
