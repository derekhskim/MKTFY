//
//  ForgotPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/31.
//

import UIKit

class ForgotPasswordViewController: MainViewController, LoginStoryboard {
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var emailView: TextFieldWithError!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sendButton: Button!
    
    // MARK: - @IBAction
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        guard let email = emailView.inputTextField.text,
        !email.isEmpty && email.isValidEmail else { return }
        
        Auth0Manager.shared.resetPassword(email: email)
        
        coordinator?.goToLoadingConfirmationVC()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            self.coordinator?.goToForgotPasswordVerificationVC()
        }
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        initializeHideKeyboard()
        
        self.emailView.inputTextField.delegate = self
        emailView.inputTextField.keyboardType = .emailAddress
                
        sendButton.isEnabled = false
    }
    
    // Triggers the error message
    private func configureView(withMessage message: String){
        emailView.showError = true
        emailView.errorMessage = message
    }
}

// MARK: - Extension
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
