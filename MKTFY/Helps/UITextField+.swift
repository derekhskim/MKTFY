//
//  UITextField+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/07.
//

import UIKit

extension UITextField {
    func setRightPaddingInTextField(padding: Double, imageName: String) {
        let rightView = UIView()
        rightView.frame = CGRect.init(x: 0.0, y: 0.0, width: padding, height: self.frame.size.height)
        let imageView = UIImageView()
        imageView.frame = CGRect.init(x: 16, y: 16, width: 24, height: 19.2)
        imageView.tintColor = UIColor.appColor(LPColor.SubtleGray)
        imageView.image = UIImage.init(systemName: imageName)
        rightView.addSubview(imageView)
        self.rightView = rightView
        self.rightViewMode = .always
    }
}
