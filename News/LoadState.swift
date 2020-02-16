//
//  LoadState.swift
//  News
//
//  Created by Yuchen Zhong on 2020-02-16.
//  Copyright © 2020 Yuchen. All rights reserved.
//

import Foundation

enum LoadState<T> {
    case loading
    case updating
    case loaded(response: T)
    case failed(error: Error)
}
