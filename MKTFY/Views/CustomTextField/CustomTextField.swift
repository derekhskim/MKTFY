//
//  CustomTextField.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/06.
//

import UIKit

@IBDesignable
class CustomTextField: LPView {
    var view: UIView!
    
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblError: UILabel!
    @IBOutlet weak var txtInputField: UITextField!
    
    @IBInspectable var title: String = "Title" {
        didSet {
            lblTitle.text = title
            
        }
        
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LPInputTextField", bundle: bundle)
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
