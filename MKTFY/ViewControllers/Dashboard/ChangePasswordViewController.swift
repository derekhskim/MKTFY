//
//  ChangePasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class ChangePasswordViewController: MainViewController, DashboardStoryboard {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var passwordView: SecureTextFieldWithLabel!
    @IBOutlet weak var confirmPasswordView: SecureTextField!
    @IBOutlet weak var characterLengthValidationImage: UIImageView!
    @IBOutlet weak var uppercaseValidationImage: UIImageView!
    @IBOutlet weak var numberValidationImage: UIImageView!
    @IBOutlet weak var updateButton: Button!
    
    // MARK: - @IBAction
    @IBAction func updateButtonTapped(_ sender: Any) {
        guard let password = passwordView.isSecureTextField.text, let confirmPassword = confirmPasswordView.isSecureTextField.text else { return }
        
        if password == confirmPassword {
            print("Update Password Button tapped")
            
            let password = Password(newPassword: password, confirmPassword: confirmPassword)
            let changePasswordEndpoint = ChangePasswordEndpoint(password: password)
            NetworkManager.shared.request(endpoint: changePasswordEndpoint) { (result: Result<NetworkManager.EmptyResponse, Error>) in
                switch result {
                case .success:
                    print("Password changed!")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("Password change failed: \(error.localizedDescription)")
                }
            }
        } else if password != confirmPassword {
            showAlert(title: "Heads up!", message: "Something happened and your password hasn't been changed.", purpleButtonTitle: "Try Again", whiteButtonTitle: "Cancel")
        } else {
            showAlert(title: "Heads up!", message: "Something happened and your password hasn't been changed.", purpleButtonTitle: "Try Again", whiteButtonTitle: "Cancel")
        }
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
        updateButton.isEnabled = false
        
        self.passwordView.isSecureTextField.delegate = self
        self.confirmPasswordView.isSecureTextField.delegate = self
    }
}

// MARK: - Extension
extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        allRequiredFieldsAreFilledOut()
    }
    
    func allRequiredFieldsAreFilledOut() -> Bool {
        guard let password = passwordView.isSecureTextField.text, let confirmPassword = confirmPasswordView.isSecureTextField.text else { return false }
                
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
        
        if isLongEnough && hasCapitalLetter && hasNumber || passwordsMatch && isLongEnough && hasCapitalLetter && hasNumber {
            configureView(withMessage: "Strong", withColor: UIColor.appColor(LPColor.GoodGreen))
        } else if isLongEnough {
            configureView(withMessage: "Weak", withColor: UIColor.appColor(LPColor.WarningYellow))
        } else {
            passwordView.showIndicator = false
        }
        
        if isLongEnough && hasCapitalLetter && hasNumber && passwordsMatch {
            updateButton.isEnabled = true
            updateButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
            return true
        } else {
            return false
        }
    }
    
    private func configureView(withMessage message: String, withColor color: UIColor) {
        passwordView.showIndicator = true
        passwordView.indicatorText = message
        passwordView.indicator.textColor = color
    }
    
}

extension ChangePasswordViewController {
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
