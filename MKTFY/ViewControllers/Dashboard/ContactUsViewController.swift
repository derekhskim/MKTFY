//
//  ContactUsViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-18.
//

import UIKit

class ContactUsViewController: MainViewController, DashboardStoryboard, UITextViewDelegate {

    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameView: TextFieldWithError!
    @IBOutlet weak var emailView: TextFieldWithError!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: Button!
    
    // MARK: - @IBAction
    @IBAction func sendButtonTapped(_ sender: Any) {
        print("Send Button Tapped!")
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        nameView.inputTextField.delegate = self
        emailView.inputTextField.delegate = self
        
        emailView.inputTextField.keyboardType = .emailAddress
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
        setupTextViewPlaceholder()
    }
    
    // MARK: - func
    func setupTextViewPlaceholder() {
        messageTextView.delegate = self
        messageTextView.text = "Your message"
        messageTextView.textColor = UIColor.appColor(LPColor.TextGray40)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.appColor(LPColor.TextGray40) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your message"
            textView.textColor = UIColor.appColor(LPColor.TextGray40)
        }
    }
}

// MARK: - Extension
extension ContactUsViewController {
    // Enable dismiss of keyboard when the user taps anywhere from the screen
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

extension ContactUsViewController: UITextFieldDelegate, UINavigationBarDelegate {
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
