//
//  ForgotPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/31.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailView: TextFieldWithError!
    @IBOutlet weak var backgroundView: UIView!
    @IBAction func sendButtonTapped(_ sender: Any) {
        let vc = LoadingConfirmationViewcontroller.storyboardInstance(storyboardName: "Login") as! LoadingConfirmationViewcontroller
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        initializeHideKeyboard()
        self.emailView.inputTextField.delegate = self
        
        view.backgroundColor = UIColor.appColor(LPColor.VoidWhite)
        backgroundView.layer.cornerRadius = CGFloat(20)
        backgroundView.clipsToBounds = true
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    // Triggers the error message
    private func configureView(withMessage message: String){
        emailView.showError = true
        emailView.errorMessage = message
    }
}

// Enable dismiss of keyboard when the user taps anywhere from the screen
extension ForgotPasswordViewController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
        if emailView.inputTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Username and/or password cannot be blank")
        } else {
            removeBorderColor()
            emailView.showError = false
        }
    }
}

// Enable dismiss of keyboard when the user taps "return"
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if emailView.inputTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Username and/or password cannot be blank")
        } else {
            removeBorderColor()
            emailView.showError = false
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
extension ForgotPasswordViewController {
    func setBorderColor() {
        let errorColor: UIColor = UIColor.appColor(LPColor.MistakeRed)
        emailView.inputTextField.layer.borderWidth = 1
        emailView.inputTextField.layer.borderColor = errorColor.cgColor
    }
    
    func removeBorderColor() {
        emailView.inputTextField.layer.borderWidth = 0
        emailView.inputTextField.layer.borderColor = nil
    }
}

// Extension to shift the view upward or downward when system keyboard appears
extension ForgotPasswordViewController {
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -100 // Move view 100 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}


extension ForgotPasswordViewController {
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     navigationController?.setNavigationBarHidden(false, animated: animated)
   }
}
