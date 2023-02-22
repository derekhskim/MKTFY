//
//  CreateAccountViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/06.
//

import UIKit

class CreateAccountViewController: UIViewController, CreatePasswordDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var firstNameField: TextFieldWithError!
    @IBOutlet weak var lastNameField: TextFieldWithError!
    @IBOutlet weak var emailField: TextFieldWithError!
    @IBOutlet weak var phoneField: TextFieldWithError!
    @IBOutlet weak var addressField: TextFieldWithError!
    @IBOutlet weak var cityField: TextFieldWithError!
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var verifyButton: Button!
    
    @IBAction func verifyButtonTapped(_ sender: Any) {
        guard let firstName = firstNameField.inputTextField.text,
              let lastName = lastNameField.inputTextField.text,
              let email = emailField.inputTextField.text,
              let phone = phoneField.inputTextField.text,
              let address = addressField.inputTextField.text,
              let city = cityField.inputTextField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty && email.isValidEmail,
              !phone.isEmpty,
              !address.isEmpty,
              !city.isEmpty else { return }
        
        let vc = CreatePasswordViewController.storyboardInstance(storyboardName: "Login") as! CreatePasswordViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var originalFrame: CGRect = .zero
    var shiftFactor: CGFloat = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        
        self.firstNameField.inputTextField.delegate = self
        self.lastNameField.inputTextField.delegate = self
        self.emailField.inputTextField.delegate = self
        self.phoneField.inputTextField.delegate = self
        self.addressField.inputTextField.delegate = self
        self.cityField.inputTextField.delegate = self
        
        /// Check if all textfields are not empty
        [firstNameField.inputTextField, lastNameField.inputTextField, emailField.inputTextField, phoneField.inputTextField, addressField.inputTextField, cityField.inputTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        verifyButton.isEnabled = false
        verifyButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
        
        emailField.inputTextField.keyboardType = .emailAddress
        phoneField.inputTextField.keyboardType = .numberPad
        
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
        
        originalFrame = wholeView.frame
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func passwordCreated(_ password: String) {
        
        let auth0Manager = Auth0Manager()
        guard let firstName = firstNameField.inputTextField.text,
              let lastName = lastNameField.inputTextField.text,
              let email = emailField.inputTextField.text,
              let phone = phoneField.inputTextField.text,
              let address = addressField.inputTextField.text,
              let city = cityField.inputTextField.text else { return }
        
        auth0Manager.signup(email: email, password: password, firstName: firstName, lastName: lastName, phone: phone, address: address, city: city) { success, error in
            if success {
                print("Sign up succeeded!")
            } else {
                print("Failed to sign up: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createPasswordVC = segue.destination as? CreatePasswordViewController {
            createPasswordVC.delegate = self
        }
    }
    
}

extension CreateAccountViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var newFrame = originalFrame
        newFrame.origin.y -= keyboardSize.height * shiftFactor
        wholeView.frame = newFrame
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        wholeView.frame = originalFrame
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func changeButtonColor(){
        let textField = TextFieldWithError()
        
        if textField.inputTextField.text!.isEmpty {
            verifyButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
        } else {
            verifyButton.setBackgroundColor(UIColor.appColor(LPColor.OccasionalPurple), forState: .normal)
        }
        
    }
}

// Enable dismiss of keyboard when the user taps anywhere from the screen
extension CreateAccountViewController {
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
extension CreateAccountViewController: UITextFieldDelegate, UINavigationBarDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let allFieldsFilled = ![firstNameField, lastNameField, emailField, phoneField, addressField, cityField].contains { $0.inputTextField.text?.isEmpty ?? true }
        
        verifyButton.isEnabled = allFieldsFilled
        verifyButton.setBackgroundColor(allFieldsFilled && emailField.inputTextField.text!.isValidEmail ? UIColor.appColor(LPColor.OccasionalPurple) : UIColor.appColor(LPColor.DisabledGray), forState: .normal)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneField.inputTextField {
            let currentText = textField.text ?? ""
            let newString = (currentText as NSString).replacingCharacters(in: range, with: string)
            let formattedText = newString.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#", addCountryCodePrefix: true)
            let countOfDigits = formattedText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression).count
            if countOfDigits > 11 {
                return false
            }
            
            textField.text = formattedText
            return false
        }
        
        return true
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            let containsTextFields = view.subviews.contains { $0 is UITextField }
            if containsTextFields {
                navigationController.setNavigationBarHidden(true, animated: true)
            } else {
                navigationController.setNavigationBarHidden(false, animated: true)
            }
        }
    }
}
