//
//  MainViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/06.
//

import UIKit

class MainViewController: UIViewController {
    
    var originalFrame: CGRect = .zero
    var shiftFactor: CGFloat = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalFrame = view.frame
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
}

// Extension to shift the view upward or downward when system keyboard appears
extension MainViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var newFrame = originalFrame
        newFrame.origin.y -= keyboardSize.height * shiftFactor
        view.frame = newFrame
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame = originalFrame
    }
}
