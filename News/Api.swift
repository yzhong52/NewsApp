//
//  Api.swift
//  News
//
//  Created by Yuchen Zhong on 2020-02-16.
//  Copyright © 2020 Yuchen. All rights reserved.
//

import Foundation

class Article: Decodable {
    let title: String
    let description: String?
    let url: URL
    let urlToImage: String?
    let content: String?
}

class ArticlesResponse: Decodable {
    let totalResults: Int
    let articles: [Article]
}
