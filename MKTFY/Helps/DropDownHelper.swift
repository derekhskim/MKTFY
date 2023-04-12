//
//  DropDownHelper.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-10.
//

import UIKit

protocol DropDownDelegate: AnyObject {
    func setDropDownSelectedOption(_ option: String, forRow row: Int)
}

class DropDownHelper {
    
    var selectionDelegate: DropDownDelegate?
    var customDropDownView: CustomDropDown?
    
    init(delegate: DropDownDelegate) {
        self.selectionDelegate = delegate
    }
    
    func setupCustomDropDown(in viewController: UIViewController, with uiView: UIView, options: [String]) {
        let rect = uiView.convert(uiView.bounds, to: viewController.view)
        customDropDownView = CustomDropDown(frame: CGRect(x: rect.maxX - 200, y: rect.maxY, width: 200, height: 300))
        customDropDownView?.options = options
        customDropDownView?.searchBarPlaceholder = "Search options"
        customDropDownView?.delegate = viewController as? CustomDropDownDelegate
        customDropDownView?.tag = uiView.tag
        viewController.view.addSubview(customDropDownView!)
    }
    
    // Manually adding ImageView "drop_down_arrow"
    func initializeImageDropDown(with textField: UITextField, options: [String]) {
        let imgViewForDropDown = UIImageView()
        imgViewForDropDown.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imgViewForDropDown.image = UIImage(named: "drop_down_arrow")
        imgViewForDropDown.isUserInteractionEnabled = true
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imgViewForDropDown.frame.width + 10, height: imgViewForDropDown.frame.height))
        containerView.addSubview(imgViewForDropDown)
        containerView.tag = textField.tag
        containerView.accessibilityLabel = "Options"
        containerView.accessibilityValue = options.joined(separator: ",")
        
        textField.rightView = containerView
        textField.rightViewMode = .always
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCustomDropDownView(_:)))
        containerView.addGestureRecognizer(tapGesture)
        
        imgViewForDropDown.contentMode = .right
    }
    
    func hideCustomDropDownView() {
        customDropDownView?.removeFromSuperview()
        customDropDownView = nil
    }
    
    @objc func showCustomDropDownView(_ sender: UITapGestureRecognizer) {
        if let containerView = sender.view, let viewController = containerView.findViewController() {
            if let dropDownView = customDropDownView {
                hideCustomDropDownView()
            } else {
                if let textField = containerView.superview as? UITextField {
                    if let optionsString = containerView.accessibilityValue {
                        let options = optionsString.components(separatedBy: ",")
                        setupCustomDropDown(in: viewController, with: textField, options: options)
                        print(options)
                    }
                }
            }
        }
    }
}

extension DropDownHelper: DropDownDelegate {
    func setDropDownSelectedOption(_ option: String, forRow row: Int) {
        if let row = self.customDropDownView?.tag {
            self.selectionDelegate?.setDropDownSelectedOption(option, forRow: row)
            print(option)
        }
        self.hideCustomDropDownView()
    }
}
