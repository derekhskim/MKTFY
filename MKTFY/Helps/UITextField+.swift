//
//  UITextField+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/07.
//

import UIKit

extension UITextField {
    func setRightPaddingInTextField(padding: Double, button: UIButton) {
        let rightView = UIView()
        rightView.frame = CGRect.init(x: 0.0, y: 0.0, width: padding, height: self.frame.size.height)
        let button = UIButton()
        button.frame = CGRect.init(x: 16, y: 16, width: 24, height: 19.2)
        button.tintColor = UIColor.appColor(LPColor.SubtleGray)
        rightView.addSubview(button)
        self.rightView = rightView
        self.rightViewMode = .always
    }
}
