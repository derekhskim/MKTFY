//
//  ForgotPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/31.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    let auth0Manager = Auth0Manager()
    
    @IBOutlet weak var emailView: TextFieldWithError!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sendButton: Button!
    @IBAction func sendButtonTapped(_ sender: Any) {
        let vc = LoadingConfirmationViewcontroller.storyboardInstance(storyboardName: "Login") as! LoadingConfirmationViewcontroller
        self.navigationController?.pushViewController(vc, animated: true)
        
        guard let email = emailView.inputTextField.text,
        !email.isEmpty && email.isValidEmail else { return }
        
        auth0Manager.resetPassword(email: email)
    }
    
    var originalFrame: CGRect = .zero
    var shiftFactor: CGFloat = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
        initializeHideKeyboard()
        
        self.emailView.inputTextField.delegate = self
        emailView.inputTextField.keyboardType = .emailAddress
                
        sendButton.isEnabled = false
        originalFrame = view.frame
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
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
        changeButtonColor()
        
        guard let email = emailView.inputTextField.text else { return }
        
        if email.isEmpty {
            setBorderColor()
            configureView(withMessage: "Username cannot be blank")
        } else if !email.isValidEmail {
            setBorderColor()
            configureView(withMessage: "Please enter a valid email address.")
        } else {
            sendButton.isEnabled = true
            removeBorderColor()
            emailView.showError = false
        }
    }
}

// Enable dismiss of keyboard when the user taps "return"
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        changeButtonColor()
        
        guard let email = emailView.inputTextField.text else { return false }

        if email.isEmpty {
            setBorderColor()
            configureView(withMessage: "Username cannot be blank")
        } else if !email.isValidEmail {
            setBorderColor()
            configureView(withMessage: "Please enter a valid email address.")
        } else {
            sendButton.isEnabled = true
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
    
    func changeButtonColor(){
        if emailView.inputTextField.text!.isEmpty || !emailView.inputTextField.text!.isValidEmail {
            sendButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
            return
        } else {
            sendButton.setBackgroundColor(UIColor.appColor(LPColor.OccasionalPurple), forState: .normal)
        }
        
    }
}

// Extension to shift the view upward or downward when system keyboard appears
extension ForgotPasswordViewController {
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
