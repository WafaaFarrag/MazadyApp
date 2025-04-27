//
//  ImageView+Extensions.swift
//  MazadyApp
//
//  Created by wafaa farrag on 26/04/2025.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL, completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                    completion?()
                }
            } else {
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
}
