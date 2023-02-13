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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        verificationTextField.view.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        
        setupNavigationBar()
        
        initializeHideKeyboard()
        self.verificationTextField.inputTextField.delegate = self
        
        view.backgroundColor = UIColor.appColor(LPColor.VoidWhite)
        backgroundView.layer.cornerRadius = CGFloat(20)
        backgroundView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
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
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -100 // Move view 100 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
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
