//
//  SecureTextFieldWithLabel.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/27.
//

import UIKit

class SecureTextFieldWithLabel: LPView {
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicator: UILabel!
    @IBOutlet weak var isSecureTextField: UITextField!
    
    let button = UIButton(type: .system)
    let eyeSlashImage = UIImage(systemName: "eye.slash")
    let eyeImage = UIImage(systemName: "eye")
    
    @IBInspectable var title: String = "Title" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var indicatorText: String = "Indicator" {
        didSet {
            indicator.text = indicatorText
        }
    }
    
    @IBInspectable var placeHolder: String = "Enter your text" {
        didSet {
            isSecureTextField.placeholder = placeHolder
        }
    }
    
    @IBInspectable var viewBackgroundColor: UIColor = .white {
        didSet {
            view.backgroundColor = viewBackgroundColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupButton()
    }
    
    private func setupButton() {
        let buttonSize = CGSize(width: 24, height: 19.2)
        let buttonFrame = CGRect(x: isSecureTextField.bounds.width - buttonSize.width - 10, y: (isSecureTextField.bounds.height - buttonSize.height) / 2, width: buttonSize.width, height: buttonSize.height)
        button.frame = buttonFrame
        button.tintColor = UIColor.gray
        
        let eyeImage = UIImage(systemName: "eye")?.withRenderingMode(.alwaysTemplate).withTintColor(.gray).resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        let eyeSlashImage = UIImage(systemName: "eye.slash")?.withRenderingMode(.alwaysTemplate).withTintColor(.gray).resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        
        let imageSize = CGSize(width: 16, height: 12)
        button.imageEdgeInsets = UIEdgeInsets(top: (buttonSize.height - imageSize.height) / 2, left: (buttonSize.width - imageSize.width) / 2, bottom: (buttonSize.height - imageSize.height) / 2, right: (buttonSize.width - imageSize.width) / 2)
        
        button.setImage(isSecureTextField.isSecureTextEntry ? eyeSlashImage : eyeImage, for: .normal)
        button.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)
        isSecureTextField.rightView = button
        isSecureTextField.rightViewMode = .always
    }
    
    
    @objc private func toggleSecureEntry() {
        isSecureTextField.isSecureTextEntry.toggle()
        button.setImage(isSecureTextField.isSecureTextEntry ? eyeSlashImage : eyeImage, for: .normal)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SecureTextField", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
}
