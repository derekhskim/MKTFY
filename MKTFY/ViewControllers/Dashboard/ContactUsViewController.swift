//
//  ContactUsViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-18.
//

import UIKit

class ContactUsViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameView: TextFieldWithError!
    @IBOutlet weak var emailView: TextFieldWithError!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: Button!
    
    // MARK: - @IBAction
    @IBAction func sendButtonTapped(_ sender: Any) {
        coordinator?.goToLoadingConfirmationVC()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            self.coordinator?.goToDashboardVC()
        }
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        configureUserDetailFields()
        
        messageTextView.delegate = self
        messageTextView.autocorrectionType = .no
        
        sendButton.isEnabled = false
        
        allFieldsFilled()
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
        setupTextViewPlaceholder()
    }
    
    // MARK: - Function
    func configureUserDetailFields() {
        guard let firstName = UserDefaults.standard.string(forKey: "firstName"), let email = UserDefaults.standard.string(forKey: "email") else { return }
        
        nameView.inputTextField.text = firstName
        emailView.inputTextField.text = email
        
        nameView.inputTextField.textColor = UIColor.appColor(LPColor.TextGray40)
        emailView.inputTextField.textColor = UIColor.appColor(LPColor.TextGray40)
        
        nameView.inputTextField.isUserInteractionEnabled = false
        emailView.inputTextField.isUserInteractionEnabled = false
    }
    
    func allFieldsFilled() {
        let messageText = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !messageText.isEmpty && messageText != "Your message" {
            sendButton.isEnabled = true
            sendButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
        } else {
            sendButton.isEnabled = false
            sendButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
        }
    }
    
    func setupTextViewPlaceholder() {
        messageTextView.delegate = self
        messageTextView.text = "Your message"
        messageTextView.textColor = UIColor.appColor(LPColor.TextGray40)
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
        allFieldsFilled()
    }
}
