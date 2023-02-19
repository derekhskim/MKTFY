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
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let vc = CreatePasswordViewController.storyboardInstance(storyboardName: "Login") as! CreatePasswordViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var originalFrame: CGRect = .zero
//    var shiftFactor: CGFloat = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()

        self.firstNameField.inputTextField.delegate = self
        self.lastNameField.inputTextField.delegate = self
        self.emailField.inputTextField.delegate = self
        self.phoneField.inputTextField.delegate = self
        self.addressField.inputTextField.delegate = self
        self.cityField.inputTextField.delegate = self
        
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
        newFrame.origin.y -= keyboardSize.height
        wholeView.frame = newFrame
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        wholeView.frame = originalFrame
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension CreateAccountViewController {
    func findView(withTags tags: [Int]) -> UIView? {
        for subview in view.subviews {
            if tags.contains(subview.tag) {
                return subview
            }
        }
        return nil
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneField.inputTextField {
            let currentText = textField.text ?? ""
            let newString = (currentText as NSString).replacingCharacters(in: range, with: string)
            let formattedText = newString.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#")
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
                // Check if any of the view's subviews are text fields
                let containsTextFields = view.subviews.contains { $0 is UITextField }
                if containsTextFields {
                    // Hide the navigation bar if there are text fields in the view
                    navigationController.setNavigationBarHidden(true, animated: true)
                } else {
                    // Show the navigation bar if there are no text fields in the view
                    navigationController.setNavigationBarHidden(false, animated: true)
                }
            }
        }
}
