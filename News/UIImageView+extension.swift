//
//  UIImageView+extension.swift
//  News
//
//  Created by Yuchen Zhong on 2020-02-16.
//  Copyright © 2020 Yuchen. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    func load(url: URLConvertible) {
        backgroundColor = .lightGray
        image = nil

        ImageManager.shared.load(url: url) { [weak self] image in
            self?.backgroundColor = nil
            self?.image = image
        }
    }
}
