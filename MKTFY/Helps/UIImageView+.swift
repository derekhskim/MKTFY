//
//  UIImageView+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-08.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL?, completionHandler: (() -> Void)? = nil) {
        guard let url = url else { return }

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                    completionHandler?()
                }
            }
        }
    }
}
