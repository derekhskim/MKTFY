//
//  ForgotPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/01.
//

import UIKit

class ForgotPasswordVerificationViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var verificationTextField: TextFieldWithError!
    
    @IBOutlet weak var verifyButton: Button!
    
    @IBAction func verifyButtonTapped(_ sender: Any) {
    }
    
    var originalFrame: CGRect = .zero
    var shiftFactor: CGFloat = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        verificationTextField.view.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        
        verifyButton.isEnabled = false
        originalFrame = view.frame
        
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
        
        initializeHideKeyboard()
        self.verificationTextField.inputTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    private func configureView(withMessage message: String){
        verificationTextField.showError = true
        verificationTextField.errorMessage = message
    }
}

// Enable dismiss of keyboard when the user taps anywhere from the screen
extension ForgotPasswordVerificationViewController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
        changeButtonColor()
        if verificationTextField.inputTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Your verification code is incorrect")
        } else {
            removeBorderColor()
            verificationTextField.showError = false
        }
    }
}

// Enable dismiss of keyboard when the user taps "return"
extension ForgotPasswordVerificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        changeButtonColor()
        if verificationTextField.inputTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Your verification code is incorrect")
        } else {
            removeBorderColor()
            verificationTextField.showError = false
        }
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

// Extension to customize border color to indicate whether a textfield is empty or not
extension ForgotPasswordVerificationViewController {
    func setBorderColor() {
        let errorColor: UIColor = UIColor.appColor(LPColor.MistakeRed)
        verificationTextField.inputTextField.layer.borderWidth = 1
        verificationTextField.inputTextField.layer.borderColor = errorColor.cgColor
    }
    
    func removeBorderColor() {
        verificationTextField.inputTextField.layer.borderWidth = 0
        verificationTextField.inputTextField.layer.borderColor = nil
    }
}

// Extension to shift the view upward or downward when system keyboard appears
extension ForgotPasswordVerificationViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var newFrame = originalFrame
        newFrame.origin.y -= keyboardSize.height * shiftFactor
        view.frame = newFrame
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame = originalFrame
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// Simple extension with a method to control the color state of the button.
extension ForgotPasswordVerificationViewController {
    func changeButtonColor(){
        if verificationTextField.inputTextField.text!.isEmpty {
            verifyButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
            return
        } else {
            verifyButton.setBackgroundColor(UIColor.appColor(LPColor.OccasionalPurple), forState: .normal)
        }
        
    }
}

// Determines where the back button should take the view controller to
extension ForgotPasswordVerificationViewController {
    @objc override func backButtonTapped() {
        self.navigationController?.popToViewController(self.navigationController!.children[1], animated: true)
    }
}
