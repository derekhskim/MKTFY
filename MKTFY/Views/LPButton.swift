//
//  RoundedButton.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import UIKit

@IBDesignable
class Button: UIButton {

    private var _highlight: Bool = false
    
    @IBInspectable var highlight: Bool {
        set {
            _highlight = newValue
        }
        get {
            return _highlight
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var cornerRadiusByHeight: Bool = false {
        didSet {
            layer.cornerRadius = self.frame.size.height/2
        }
    }
    
    @IBInspectable var roundButton: Bool = false {
        didSet {
            layer.cornerRadius = self.frame.size.width / 2
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }
    
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: 0,height: 3)
            layer.shadowOpacity = 1
        }
    }
    
    
    @IBInspectable var shadowOpacity: CGFloat = 0.0 {
        didSet {
//            layer.shadowOpacity = Float(shadowOpacity.hashValue)
//            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        
        didSet {
            
            layer.shadowOpacity = Float(shadowRadius.hashValue)
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var enable:Bool = true {
        didSet {
//            self.isUserInteractionEnabled = enable
            self.alpha = (enable == true ? 1 : 0.35)
            self.isEnabled = enable
            
        }
    }
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
    }
}

// Extension to change background color of UIButton
extension UIButton {
  func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
    let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
      color.setFill()
      UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
    }
    setBackgroundImage(colorImage, for: controlState)
  }
}
