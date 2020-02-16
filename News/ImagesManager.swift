//
//  ImagesManager.swift
//  News
//
//  Created by Yuchen Zhong on 2020-02-16.
//  Copyright © 2020 Yuchen. All rights reserved.
//

import UIKit
import Alamofire

class ImageManager {

    private let session = Alamofire.Session()
    
    static let shared = ImageManager()

    func load(url: URLConvertible, completionHandler: @escaping (UIImage) -> Void) -> Void {
        session.request(url).responseData(
            queue: DispatchQueue.global(),
            completionHandler: { response in
                if let data = response.data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                }
        })
    }
}
