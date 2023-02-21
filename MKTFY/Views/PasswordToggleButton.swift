//
//  PasswordToggleButton.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/21.
//

import UIKit

class PasswordToggleButton: UIButton {
    
    private var isPasswordVisible = false {
        didSet {
            let imageName = isPasswordVisible ? "eye.slash" : "eye"
            setImage(UIImage(systemName: imageName), for: .normal)
            passwordView.isSecureTextEntry = !isPasswordVisible
        }
    }
    
    var passwordView: UITextField! {
        didSet {
            isPasswordVisible = false
            addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    func setSecureEntry(_ isSecureEntry: Bool) {
        isPasswordVisible = !isSecureEntry
    }
    
    @objc private func buttonTapped() {
        isPasswordVisible = !isPasswordVisible
    }
}

