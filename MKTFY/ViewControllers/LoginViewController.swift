//
//  LoginViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    let errorMessageLabel = UILabel()
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
    }
    
    @IBOutlet weak var cloudsImageView: UIImageView!
    
    @IBAction func loginButton(_ sender: Any) {
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
}

extension LoginViewController {
    
    @objc func loginButton(sender: UIButton) {
        login()
    }
    
    private func login() {
        guard let emailTextField = emailTextField, let passwordTextField = passwordTextField else {
            assertionFailure("Email and/or password should never be nil.")
            return
        }
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            configureView(withMessage: "Username and/or password cannot be blank")
            return
        }
        
        if emailTextField.text == "" && passwordTextField.text == "" {
            
        } else {
            configureView(withMessage: "Incorrect Username and/or password")
        }
        
    }
    
    private func configureView(withMessage message: String){
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }
}

// Enable dismiss of keyboard when the user taps anywhere from the screen
extension LoginViewController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

// Enable dismiss of keyboard when the user taps "return"
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

