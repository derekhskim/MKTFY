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

class CreatePasswordViewController: UIViewController {

    @IBOutlet weak var passwordView: SecureTextField!
    @IBOutlet weak var confirmPasswordView: SecureTextField!
    
    @IBAction func createPasswordButtonTapped(_ sender: Any) {
        guard let password = passwordView.isSecureTextField.text else { return }
        delegate?.passwordCreated(password)
        self.navigationController?.popToViewController(self.navigationController!.children[0], animated: true)
    }
    
    weak var delegate: CreatePasswordDelegate?
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
        
        self.passwordView.isSecureTextField.delegate = self
        self.confirmPasswordView.isSecureTextField.delegate = self
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
        
    }
}
