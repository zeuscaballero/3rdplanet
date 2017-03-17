//
//  ImageController.swift
//  3rdplanet
//
//  Created by zeus on 3/15/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation
import UIKit

class ImageController {
    static func image(forURL url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else { fatalError("Image URL optional is nil.") }
        
        NetworkController.performRequest(for: url, httpMethod: .get) { (data, error) in
            guard let data = data,
                let image = UIImage(data: data) else {
                    DispatchQueue.main.async { completion(nil) }
                    return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
