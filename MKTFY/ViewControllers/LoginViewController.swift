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
        let vc = ForgotPasswordViewController.storyboardInstance(storyboardName: "Login") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var cloudsImageView: UIImageView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButtonTapped(_ sender: Any) {
        login()
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let vc = CreateAccountViewController.storyboardInstance(storyboardName: "Login") as! CreateAccountViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            loginButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .disabled)
        } else {
            loginButton.setBackgroundColor(UIColor.appColor(LPColor.WarningYellow), forState: .normal)
        }
        
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
            
            return
        } else if emailTextField.text!.isEmpty == false {
            
        }
        
        // Simple Tester
        if emailTextField.text == "d" && passwordTextField.text == "d" {
            print("It's correct...maybe?")
            loginButton.configuration?.showsActivityIndicator = true
            
        } else {
            configureView(withMessage: "Incorrect Username and/or password")
        }
        
    }
    
    private func configureView(withMessage message: String){
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }
}

// Simple extension with a method to control the color state of the button.
extension LoginViewController {
    func changeButtonColor(){
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            loginButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
            return
        } else {
            loginButton.setBackgroundColor(UIColor.appColor(LPColor.WarningYellow), forState: .normal)
        }
 
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
        changeButtonColor()
        if emailTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Username and/or password cannot be blank")
        } else {
            removeBorderColor()
            errorMessageLabel.isHidden = true
        }
    }
}

// Enable dismiss of keyboard when the user taps "return"
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        changeButtonColor()
        if emailTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Username and/or password cannot be blank")
        } else {
            removeBorderColor()
            errorMessageLabel.isHidden = true
        }
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

// Extension to shift the view upward or downward when system keyboard appears
extension LoginViewController {
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -100 // Move view 100 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}

// Extension to customize border color to indicate whether a textfield is empty or not
extension LoginViewController {
    func setBorderColor() {
        let errorColor: UIColor = UIColor.appColor(LPColor.MistakeRed)
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = errorColor.cgColor
    }
    
    func removeBorderColor() {
        emailTextField.layer.borderWidth = 0
        emailTextField.layer.borderColor = nil
    }
}

extension LoginViewController {
    
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     navigationController?.setNavigationBarHidden(true, animated: animated)
   }

   override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     navigationController?.setNavigationBarHidden(false, animated: animated)
   }
    
}

