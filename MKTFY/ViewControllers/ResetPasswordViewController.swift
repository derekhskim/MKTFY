//
//  ResetPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/20.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var passwordView: SecureTextField!
    @IBOutlet weak var confirmPasswordView: SecureTextField!
    
    @IBOutlet weak var characterLengthValidationImage: UIImageView!
    @IBOutlet weak var uppercaseValidationImage: UIImageView!
    @IBOutlet weak var numberValidationImage: UIImageView!
    @IBOutlet weak var resetPasswordButton: Button!
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetPasswordButton.isEnabled = false
        
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
        
        validatePassword()
    }
    
    
}

// Determines where the back button should take the view controller to
extension ResetPasswordViewController {
    @objc override func backButtonTapped() {
        self.navigationController?.popToViewController(self.navigationController!.children[1], animated: true)
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validatePassword()
    }
    
    func validatePassword() {
        guard let password = passwordView.isSecureTextField.text, let confirmPassword = confirmPasswordView.isSecureTextField.text else { return }
        
        let passwordsMatch = (password == confirmPassword)
        
        let isLongEnough = (password.count >= 6)
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let capitalLetterTest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let hasCapitalLetter = capitalLetterTest.evaluate(with: password)
        
        let numberRegEx  = ".*[0-9]+.*"
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let hasNumber = numberTest.evaluate(with: password)
        
        // Update image based on validation results
        if isLongEnough {
            characterLengthValidationImage.image = UIImage(named: "password_validation_checked")
        } else {
            characterLengthValidationImage.image = UIImage(named: "password_validation_unchecked")
        }
        if hasCapitalLetter {
            uppercaseValidationImage.image = UIImage(named: "password_validation_checked")
        } else {
            uppercaseValidationImage.image = UIImage(named: "password_validation_unchecked")
        }
        if hasNumber {
            numberValidationImage.image = UIImage(named: "password_validation_checked")
        } else {
            numberValidationImage.image = UIImage(named: "password_validation_unchecked")
        }
            
        if passwordsMatch && isLongEnough && hasCapitalLetter && hasNumber {
            resetPasswordButton.isEnabled = true
        } else {
            resetPasswordButton.isEnabled = false
        }
    }

}
