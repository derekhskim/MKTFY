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
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var passwordView: SecureTextFieldWithLabel!
    @IBOutlet weak var confirmPasswordView: SecureTextField!
    
    @IBOutlet weak var characterLengthValidationImage: UIImageView!
    @IBOutlet weak var uppercaseValidationImage: UIImageView!
    @IBOutlet weak var numberValidationImage: UIImageView!
    
    @IBOutlet weak var checkBoxTapped: CheckBox!
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
        
        initializeHideKeyboard()
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
        
        self.passwordView.isSecureTextField.delegate = self
        self.confirmPasswordView.isSecureTextField.delegate = self
        
        createMyAccountButton.isEnabled = false
        allRequiredFieldsAreFilledOut()
        
        checkBoxTapped.addTarget(self, action: #selector(checkBoxValueChanged(sender:)), for: .valueChanged)
        
        originalFrame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func checkBoxValueChanged(sender: CheckBox) {
        if sender.isChecked && allRequiredFieldsAreFilledOut() {
            createMyAccountButton.isEnabled = true
            createMyAccountButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
        } else {
            createMyAccountButton.isEnabled = false
            createMyAccountButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
        }
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
            if checkBoxTapped.isChecked {
                createMyAccountButton.isEnabled = true
                createMyAccountButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
            }
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
