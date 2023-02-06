//
//  ForgotPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/31.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBAction func sendButtonTapped(_ sender: Any) {
        print("Ouch")
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initializeHideKeyboard()
        self.emailTextField.delegate = self
        
        view.backgroundColor = UIColor.appColor(LPColor.VoidWhite)
        backgroundView.layer.cornerRadius = CGFloat(20)
        backgroundView.clipsToBounds = true
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    private func configureView(withMessage message: String){
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }
}

// Enable dismiss of keyboard when the user taps anywhere from the screen
extension ForgotPasswordViewController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
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
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
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

// Extension to customize border color to indicate whether a textfield is empty or not
extension ForgotPasswordViewController {
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

// Extension to shift the view upward or downward when system keyboard appears
extension ForgotPasswordViewController {
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -100 // Move view 100 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}


extension ForgotPasswordViewController {
    override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     navigationController?.setNavigationBarHidden(false, animated: animated)
   }
}
