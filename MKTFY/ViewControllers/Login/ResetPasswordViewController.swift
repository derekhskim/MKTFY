//
//  ResetPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/20.
//

import UIKit

class ResetPasswordViewController: MainViewController, LoginStoryboard {
    
    var mgmtAccessToken: String!
    var email: String = ""
    var userId: String = ""
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var passwordView: SecureTextFieldWithLabel!
    @IBOutlet weak var confirmPasswordView: SecureTextField!
    
    @IBOutlet weak var characterLengthValidationImage: UIImageView!
    @IBOutlet weak var uppercaseValidationImage: UIImageView!
    @IBOutlet weak var numberValidationImage: UIImageView!
    @IBOutlet weak var resetPasswordButton: Button!
    
    // MARK: - @IBAction
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        guard let newPassword = passwordView.isSecureTextField.text else { return }
        
        let headers = [
            "content-type": "application/json",
            "authorization": "Bearer \(mgmtAccessToken!)"
        ]
        let parameters = [
            "password": newPassword,
            "connection": databaseConnection,
        ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string:  "https://\(devDomain)/api/v2/users/auth0%7C\(userId)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
            }
        })
        
        dataTask.resume()
        
        DispatchQueue.main.async {
            self.navigationController?.popToViewController(self.navigationController!.children[0], animated: true)
        }
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
        self.passwordView.isSecureTextField.delegate = self
        self.confirmPasswordView.isSecureTextField.delegate = self
        
        passwordView.showIndicator = false
        resetPasswordButton.isEnabled = false
        
        validatePassword()
        
    }
}

// MARK: - Extension
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
        
        if isLongEnough && hasCapitalLetter && hasNumber || passwordsMatch && isLongEnough && hasCapitalLetter && hasNumber {
                configureView(withMessage: "Strong", withColor: UIColor.appColor(LPColor.GoodGreen))
            } else if isLongEnough {
                configureView(withMessage: "Weak", withColor: UIColor.appColor(LPColor.WarningYellow))
            } else {
                passwordView.showIndicator = false
            }
        
        if passwordsMatch && isLongEnough && hasCapitalLetter && hasNumber {
            resetPasswordButton.isEnabled = true
            resetPasswordButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
        } else {
            resetPasswordButton.isEnabled = false
            resetPasswordButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
        }
    }
    
    private func configureView(withMessage message: String, withColor color: UIColor) {
        passwordView.showIndicator = true
        passwordView.indicatorText = message
        passwordView.indicator.textColor = color
    }
    
}

extension ResetPasswordViewController {
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
