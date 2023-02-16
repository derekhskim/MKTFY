//
//  CreateAccountViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/06.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var firstNameField: TextFieldWithError!
    @IBOutlet weak var lastNameField: TextFieldWithError!
    @IBOutlet weak var emailField: TextFieldWithError!
    @IBOutlet weak var phoneField: TextFieldWithError!
    @IBOutlet weak var addressField: TextFieldWithError!
    @IBOutlet weak var cityField: TextFieldWithError!
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let vc = CreatePasswordViewController.storyboardInstance(storyboardName: "Login") as! CreatePasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        let user = Users()
        let auth0Manager = Auth0Manager()
        
        guard let firstName = firstNameField.inputTextField.text,
              let lastName = lastNameField.inputTextField.text,
              let email = emailField.inputTextField.text,
              let phone = phoneField.inputTextField.text,
              let address = addressField.inputTextField.text,
              let city = cityField.inputTextField.text else { return }
        
        auth0Manager.signup(email: email, password: "K123456_!", firstName: firstName, lastName: lastName, phone: phone, address: address, city: city) { success, error in
                    if success {
                        print("Sign up succeeded!")
                    } else {
                        print("Failed to sign up: \(error?.localizedDescription ?? "unknown error")")
                    }
                }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        
        self.firstNameField.inputTextField.delegate = self
        self.lastNameField.inputTextField.delegate = self
        self.emailField.inputTextField.delegate = self
        self.phoneField.inputTextField.delegate = self
        self.addressField.inputTextField.delegate = self
        self.cityField.inputTextField.delegate = self
        
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
}

extension CreateAccountViewController {
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -100 // Move view 100 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
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
extension CreateAccountViewController: UITextFieldDelegate {
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
