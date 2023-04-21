//
//  UIImageView+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-08.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(from url: URL?, completionHandler: (() -> Void)? = nil) {
        guard let url = url else {
            self.image = UIImage(named: "no-image")
            return
        }

        let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: resource, placeholder: UIImage(named: "no-image"), completionHandler: { result in
            switch result {
            case .success(_):
                completionHandler?()
            case .failure(_):
                self.image = UIImage(named: "no-image")
            }
        })
    }
}
