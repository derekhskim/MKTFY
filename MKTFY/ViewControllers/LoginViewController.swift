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
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        print("Too bad..")
    }
    
    @IBOutlet weak var cloudsImageView: UIImageView!
    
    @IBAction func loginButton(_ sender: Any) {
        login()
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        print("You cannot make an account yet.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
}

// Validating the Login Process
extension LoginViewController {
    
    private func login() {
        guard let emailTextField = emailTextField, let passwordTextField = passwordTextField else {
            assertionFailure("Email and/or password should never be nil.")
            return
        }
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            configureView(withMessage: "Username and/or password cannot be blank")
            return
        }
        
        if emailTextField.text == "d" && passwordTextField.text == "d" {
            print("It's correct...maybe?")
            errorMessageLabel.isHidden = true
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

extension LoginViewController {
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}
