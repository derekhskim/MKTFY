//
//  ForgotPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/01.
//

import UIKit
import Auth0

class ForgotPasswordVerificationViewController: MainViewController, LoginStoryboard {
    
    let auth0Manager = Auth0Manager()
    var email: String!
    var mgmtAccessToken: String = ""
    var userId: String = ""
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var verificationTextField: TextFieldWithError!
    @IBOutlet weak var codeSentLabel: UILabel!
    @IBOutlet weak var verifyButton: Button!
    
    // MARK: - @IBAction
    @IBAction func verifyButtonTapped(_ sender: Any) {
        
        let cleanVerificationCode = verificationTextField.inputTextField.text!.replacingOccurrences(of: "-", with: "")
        
        guard let email = email else { return }
        
        getManagementAccessToken { token in
            guard let accessToken = token else {
                print("Failed to get management access token")
                return
            }
            
            DispatchQueue.main.async {
                self.mgmtAccessToken = accessToken
                
                let headers = ["authorization": "Bearer \(self.mgmtAccessToken)"]
                
                let request = NSMutableURLRequest(url: NSURL(string: "https://\(devDomain)/api/v2/users?q=email:%22\(email)%22&search_engine=v3")! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print("error: \(String(describing: error))")
                    } else {
                        if response is HTTPURLResponse {
                            if let data = data {
                                do {
                                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                                    if let users = json {
                                        for user in users {
                                            if let identities = user["identities"] as? [[String:Any]] {
                                                for identity in identities {
                                                    if let provider = identity["provider"] as? String, provider == "auth0" {
                                                        if let user_id = identity["user_id"] as? String {
                                                            self.userId = user_id
                                                            UserDefaults.standard.set(self.userId, forKey: "user_id")
                                                            
                                                            self.auth0Manager.auth0.login(email: email, code: cleanVerificationCode, audience: "https://\(devDomain)/api/v2/", scope: "openid profile")
                                                                .start { result in
                                                                    switch result {
                                                                    case .success(_):
                                                                        UserDefaults.standard.set(self.mgmtAccessToken, forKey: "accessToken")
                                                                        
                                                                        DispatchQueue.main.async {
                                                                            let vc = ResetPasswordViewController.storyboardInstance(storyboardName: "Login") as! ResetPasswordViewController
                                                                            vc.email = email
                                                                            vc.mgmtAccessToken = self.mgmtAccessToken
                                                                            vc.userId = self.userId
                                                                            self.navigationController?.pushViewController(vc, animated: true)
                                                                        }
                                                                    case .failure(_):
                                                                        DispatchQueue.main.async {
                                                                            self.showAlert(title: "Code is not valid", message: "Please double check the code you have received and enter it again", buttonTitle: "Okay")
                                                                        }
                                                                    }
                                                                }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } catch let error {
                                    print("Error parsing JSON: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                })
                dataTask.resume()
            }
        }
    }
    
    @IBAction func sendCodeAgainButtonTapped(_ sender: Any) {
        guard let email = email else { return }
        
        Auth0Manager.shared.resetPassword(email: email)
        
        showAlert(title: "Success!", message: "Verification code has been resent to you!", buttonTitle: "Okay")
    }
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = email {
            let message = "A code has been sent to your email \(email), Please enter the verification code."
            codeSentLabel.text = message
        }
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
        initializeHideKeyboard()
        self.verificationTextField.inputTextField.delegate = self
        verificationTextField.inputTextField.keyboardType = .numberPad
    
    }
    
    private func configureView(withMessage message: String){
        verificationTextField.showError = true
        verificationTextField.errorMessage = message
    }
}

// MARK: - Extension
// Enable dismiss of keyboard when the user taps anywhere from the screen
extension ForgotPasswordVerificationViewController {
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
        changeButtonColor()
        if verificationTextField.inputTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Your verification code is incorrect")
        } else {
            removeBorderColor()
            verificationTextField.showError = false
        }
    }
}

// Enable dismiss of keyboard when the user taps "return"
extension ForgotPasswordVerificationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        changeButtonColor()
        if verificationTextField.inputTextField.text!.isEmpty {
            setBorderColor()
            configureView(withMessage: "Your verification code is incorrect")
        } else {
            removeBorderColor()
            verificationTextField.showError = false
        }
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = verificationTextField.inputTextField.text else { return false }
        
        if string.isEmpty {
            return true
        }
        
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let numericText = updatedText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if numericText.count > 6 {
            return false
        }
        
        var formattedText = ""
        var index = numericText.startIndex
        for i in 0..<3 {
            if index < numericText.endIndex {
                let nextIndex = numericText.index(index, offsetBy: min(2, numericText.distance(from: index, to: numericText.endIndex)))
                let substring = numericText[index..<nextIndex]
                formattedText += substring
                index = nextIndex
            }
            if i < 2 {
                formattedText += "-"
            }
        }
        
        verificationTextField.inputTextField.text = formattedText
        
        if numericText.count == 6 {
            verifyButton.isEnabled = true
        } else {
            verifyButton.isEnabled = false
        }
        return false
    }
    
}

// Extension to customize border color to indicate whether a textfield is empty or not
extension ForgotPasswordVerificationViewController {
    func setBorderColor() {
        let errorColor: UIColor = UIColor.appColor(LPColor.MistakeRed)
        verificationTextField.inputTextField.layer.borderWidth = 1
        verificationTextField.inputTextField.layer.borderColor = errorColor.cgColor
    }
    
    func removeBorderColor() {
        verificationTextField.inputTextField.layer.borderWidth = 0
        verificationTextField.inputTextField.layer.borderColor = nil
    }
}

// Simple extension with a method to control the color state of the button.
extension ForgotPasswordVerificationViewController {
    func changeButtonColor(){
        if verificationTextField.inputTextField.text!.isEmpty {
            verifyButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
            return
        } else {
            verifyButton.setBackgroundColor(UIColor.appColor(LPColor.OccasionalPurple), forState: .normal)
        }
        
    }
}

// Determines where the back button should take the view controller to
extension ForgotPasswordVerificationViewController {
    @objc override func backButtonTapped() {
        self.navigationController?.popToViewController(self.navigationController!.children[1], animated: true)
    }
}
