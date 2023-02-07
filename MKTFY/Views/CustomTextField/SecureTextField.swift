//
//  SecuredTextField.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/07.
//

import UIKit

@IBDesignable
class SecureTextField: LPView {
    var view: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isSecureTextField: UITextField!
    
    @IBInspectable var title: String = "Title" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var placeHolder: String = "Enter your text" {
        didSet {
            isSecureTextField.placeholder = placeHolder
        }
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        
    }
}
