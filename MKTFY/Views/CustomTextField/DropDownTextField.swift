//
//  DropDownTextField.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-18.
//

import UIKit

@IBDesignable
class DropDownTextField: UIView, DropDownDelegate {
    
    // MARK: - Properties
    var view: UIView!
    var dropDownHelper: DropDownHelper!
    var options: [String] = [] {
        didSet {
            dropDownHelper?.initializeImageDropDown(with: inputTextField, options: options)
        }
    }
    
    // MARK: - @IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    // MARK: - @IBInspectable
    @IBInspectable var title: String = "Title" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var placeHolder: String = "Enter your text" {
        didSet {
            inputTextField.placeholder = placeHolder
        }
    }
    
    @IBInspectable var viewBackgroundColor: UIColor = .white {
        didSet {
            view.backgroundColor = viewBackgroundColor
        }
    }
    
    @IBInspectable var textFieldTag: Int = 0 {
        didSet {
            inputTextField.tag = textFieldTag
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DropDownTextField", bundle: bundle)
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
        self.backgroundColor = viewBackgroundColor
        xibSetup()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropDownHelper = DropDownHelper(delegate: self)
        dropDownHelper.selectionDelegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = viewBackgroundColor
        xibSetup()
        
    }
    
    func setDropDownSelectedOption(_ option: String, forRow row: Int) {
        if inputTextField.tag == row {
            inputTextField.text = option
        }
    }
}
