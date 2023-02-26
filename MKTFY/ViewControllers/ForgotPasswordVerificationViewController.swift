//
//  ForgotPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/01.
//

import UIKit
import Auth0

class ForgotPasswordVerificationViewController: UIViewController {
    
    let auth0Manager = Auth0Manager()
    var email: String!
    var mgmtAccessToken: String = ""
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var verificationTextField: TextFieldWithError!
    @IBOutlet weak var codeSentLabel: UILabel!
    
    @IBOutlet weak var verifyButton: Button!
    
    @IBAction func verifyButtonTapped(_ sender: Any) {
        
        guard let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plistData = FileManager.default.contents(atPath: plistPath),
              let plist = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any],
              let clientId = plist["clientId"] as? String,
              let clientSecret = plist["clientSecret"] as? String else {
            fatalError("Could not read credentials from .plist file.")
        }
              
        
        let headers = ["content-type": "application/x-www-form-urlencoded"]

        let postData = NSMutableData(data: "grant_type=client_credentials".data(using: String.Encoding.utf8)!)
        postData.append("&client_id=\(clientId)".data(using: String.Encoding.utf8)!)
        postData.append("&client_secret=\(clientSecret)".data(using: String.Encoding.utf8)!)
        postData.append("&audience=https://dev-vtoay0l3h78iuz2e.us.auth0.com/api/v2/".data(using: String.Encoding.utf8)!)

        let request = NSMutableURLRequest(url: NSURL(string: "https://dev-vtoay0l3h78iuz2e.us.auth0.com/oauth/token")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let jsonData = data {
                        do {
                            let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any]
                            if let accessToken = jsonDict?["access_token"] as? String {
                                print("accessToken: \(accessToken)")
                                self.mgmtAccessToken = accessToken
                            }
                        } catch {
                            print("Error parsing JSON: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("HTTP response status code: \(httpResponse.statusCode)")
                }
            }
        }
        dataTask.resume()
        
        let cleanVerificationCode = verificationTextField.inputTextField.text!.replacingOccurrences(of: "-", with: "")
        
        guard let email = email else { return }
        
        auth0Manager.auth0.login(email: email, code: cleanVerificationCode, audience: "https://dev-vtoay0l3h78iuz2e.us.auth0.com/api/v2/", scope: "openid profile")
            .start { result in
                switch result {
                case .success(let credentials):
                    UserDefaults.standard.set(self.mgmtAccessToken, forKey: "accessToken")
                    
                    DispatchQueue.main.async {
                        let vc = ResetPasswordViewController.storyboardInstance(storyboardName: "Login") as! ResetPasswordViewController
                        vc.email = email
                        vc.mgmtAccessToken = self.mgmtAccessToken
                        print("mgmtAccessToken: \(self.mgmtAccessToken)")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            }
    }
    
    var originalFrame: CGRect = .zero
    var shiftFactor: CGFloat = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = email {
            let message = "A code has been sent to your email \(email), Please enter the verification code."
            codeSentLabel.text = message
        }
        
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
        
        initializeHideKeyboard()
        self.verificationTextField.inputTextField.delegate = self
        verificationTextField.inputTextField.keyboardType = .numberPad
        
        originalFrame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    private func configureView(withMessage message: String){
        verificationTextField.showError = true
        verificationTextField.errorMessage = message
    }
}

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

// Extension to shift the view upward or downward when system keyboard appears
extension ForgotPasswordVerificationViewController {
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
