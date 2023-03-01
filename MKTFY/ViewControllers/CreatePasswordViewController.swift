//
//  CreatePasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/14.
//

import UIKit

protocol CreatePasswordDelegate: AnyObject {
    func passwordCreated(_ password: String)
}

class CreatePasswordViewController: UIViewController, LoginStoryboard {

    @IBOutlet weak var passwordView: SecureTextFieldWithLabel!
    @IBOutlet weak var confirmPasswordView: SecureTextField!
    
    @IBOutlet weak var characterLengthValidationImage: UIImageView!
    @IBOutlet weak var uppercaseValidationImage: UIImageView!
    @IBOutlet weak var numberValidationImage: UIImageView!
    
    @IBOutlet weak var agreementLabel: UILabel!
    
    @IBOutlet weak var createMyAccountButton: Button!
    @IBAction func createMyAccountButtonTapped(_ sender: Any) {
        guard let password = passwordView.isSecureTextField.text else { return }
        delegate?.passwordCreated(password)
        self.navigationController?.popToViewController(self.navigationController!.children[0], animated: true)
    }
    
    var originalFrame: CGRect = .zero
    var shiftFactor: CGFloat = 0.25
    
    weak var delegate: CreatePasswordDelegate?
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = NavigationTapGestureRecognizer(target: self, action: #selector(labelTapped))
        tapGestureRecognizer.viewController = self
        agreementLabel.addGestureRecognizer(tapGestureRecognizer)
        agreementLabel.isUserInteractionEnabled = true
        
        let string = NSMutableAttributedString(string: "By checking this box, you agree to our ")
        let attributedTermsOfService = NSMutableAttributedString(string: "Terms of Service", attributes: [NSAttributedString.Key.link: NavigationTapGestureRecognizer(), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: UIColor.appColor(LPColor.LightestPurple)!, NSAttributedString.Key.foregroundColor: UIColor.appColor(LPColor.LightestPurple)!])
        let additionalString = NSMutableAttributedString(string: " and our ")
        let attributedPrivacyPolicy = NSMutableAttributedString(string: "Privacy Policy", attributes: [NSAttributedString.Key.link: URL(string: "https://www.github.com/treasure3210")!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: UIColor.appColor(LPColor.LightestPurple)!, NSAttributedString.Key.foregroundColor: UIColor.appColor(LPColor.LightestPurple)!])
        
        string.append(attributedTermsOfService)
        string.append(additionalString)
        string.append(attributedPrivacyPolicy)

        agreementLabel.attributedText = string
        
        initializeHideKeyboard()
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
        
        self.passwordView.isSecureTextField.delegate = self
        self.confirmPasswordView.isSecureTextField.delegate = self
        
        createMyAccountButton.isEnabled = false
        validatePassword()
        
        originalFrame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func labelTapped() {
        let vc = DashboardViewController.storyboardInstance(storyboardName: "Dashboard") as! DashboardViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CreatePasswordViewController: UITextFieldDelegate {
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
            createMyAccountButton.isEnabled = true
        } else {
            createMyAccountButton.isEnabled = false
        }
    }
    
    private func configureView(withMessage message: String, withColor color: UIColor) {
        passwordView.showIndicator = true
        passwordView.indicatorText = message
        passwordView.indicator.textColor = color
    }

}

extension CreatePasswordViewController {
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
