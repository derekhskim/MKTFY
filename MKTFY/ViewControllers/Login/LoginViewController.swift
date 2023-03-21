//
//  LoginViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import UIKit
import Auth0

class LoginViewController: MainViewController, LoginStoryboard {
    
    weak var coordinator: MainCoordinator?
        
    // MARK: - @IBOutlet
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var emailView: TextFieldWithError!
    @IBOutlet weak var passwordView: SecureTextField!
    @IBOutlet weak var cloudsImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - @IBAction
    @IBAction func forgotPasswordButton(_ sender: Any) {
        coordinator?.goToForgotPasswordVC()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailView.inputTextField.text,
              let password = passwordView.isSecureTextField.text else { return }
        
        Auth0Manager.shared.loginWithEmail(email, password: password) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.coordinator?.goToDashboardVC()
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Login Failed", message: "Please double check your email or password", purpleButtonTitle: "Try Again", whiteButtonTitle: "Cancel")
                    
                }
            }
        }
    }

    @IBAction func createAccountButton(_ sender: Any) {
        coordinator?.goToCreateAccountVC()
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailView.inputTextField.text = "treasure3210@gmail.com"
        passwordView.isSecureTextField.text = "K121212"
        
        initializeHideKeyboard()
        
        self.emailView.inputTextField.delegate = self
        self.passwordView.isSecureTextField.delegate = self
        
        emailView.inputTextField.keyboardType = .emailAddress
        
        loginButton.isEnabled = false
    }
}

// MARK: - Extension
extension LoginViewController {
    // Simple method to control the color state of the button.
    func changeButtonColor(){
        if emailView.inputTextField.text!.isEmpty || !emailView.inputTextField.text!.isValidEmail || passwordView.isSecureTextField.text!.isEmpty {
            loginButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
            return
        } else {
            loginButton.setBackgroundColor(UIColor.appColor(LPColor.WarningYellow), forState: .normal)
        }
        
    }
    
    // Triggers the error message
    private func configureView(withMessage message: String){
        emailView.showError = true
        emailView.errorMessage = message
    }
    
    // Extension to customize border color to indicate whether a textfield is empty or not
    func setBorderColor() {
        let errorColor: UIColor = UIColor.appColor(LPColor.MistakeRed)
        emailView.inputTextField.layer.borderWidth = 1
        emailView.inputTextField.layer.borderColor = errorColor.cgColor
    }
    
    func removeBorderColor() {
        emailView.inputTextField.layer.borderWidth = 0
        emailView.inputTextField.layer.borderColor = nil
    }
    
    // Enable dismiss of keyboard when the user taps anywhere from the screen
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
        changeButtonColor()
        
        if emailView.inputTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Username cannot be blank")
        } else if !emailView.inputTextField.text!.isValidEmail {
            setBorderColor()
            configureView(withMessage: "Please enter a valid email address.")
        } else {
            loginButton.isEnabled = true
            removeBorderColor()
            emailView.showError = false
        }
    }
}

// Enable dismiss of keyboard when the user taps "return"
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        changeButtonColor()
        
        if emailView.inputTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Username cannot be blank")
        } else if !emailView.inputTextField.text!.isValidEmail {
            setBorderColor()
            configureView(withMessage: "Please enter a valid email address.")
        } else {
            loginButton.isEnabled = true
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

