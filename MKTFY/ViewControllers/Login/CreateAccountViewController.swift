//
//  CreateAccountViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/06.
//

import UIKit

class CreateAccountViewController: MainViewController, CreatePasswordDelegate, LoginStoryboard, UIScrollViewDelegate, UISearchBarDelegate {
    
    var customDropDownView: UIView?
    var dropDownView: UIView!
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var firstNameField: TextFieldWithError!
    @IBOutlet weak var lastNameField: TextFieldWithError!
    @IBOutlet weak var emailField: TextFieldWithError!
    @IBOutlet weak var phoneField: TextFieldWithError!
    @IBOutlet weak var addressField: TextFieldWithError!
    @IBOutlet weak var cityField: TextFieldWithError!
    @IBOutlet var wholeView: UIView!
    @IBOutlet weak var nextButton: Button!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - @IBAction
    @IBAction func nextButtonTapped(_ sender: Any) {
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
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        initializeImageDropDown()
        
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
        
        nextButton.isEnabled = false
        nextButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
        
        emailField.inputTextField.keyboardType = .emailAddress
        phoneField.inputTextField.keyboardType = .numberPad
        
        scrollView.delegate = self
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let options = ["Calgary", "Camrose", "Brooks"]
        let filteredOptions = searchText.isEmpty ? options : options.filter { $0.lowercased().contains(searchText.lowercased()) }
        
        for (index, button) in dropDownView.subviews.compactMap({ $0 as? UIButton }).enumerated() {
            if filteredOptions.indices.contains(index) {
                let option = filteredOptions[index]
                button.setTitle(option, for: .normal)
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
    }
    
}

// MARK: - Extension
extension CreateAccountViewController {
    func changeButtonColor(){
        let textField = TextFieldWithError()
        
        if textField.inputTextField.text!.isEmpty {
            nextButton.setBackgroundColor(UIColor.appColor(LPColor.DisabledGray), forState: .normal)
        } else {
            nextButton.setBackgroundColor(UIColor.appColor(LPColor.OccasionalPurple), forState: .normal)
        }
        
    }
    
    func initializeImageDropDown() {
        let imgViewForDropDown = UIImageView()
        imgViewForDropDown.frame = CGRect(x: 0, y: 0, width: 30, height: 48)
        imgViewForDropDown.image = UIImage(named: "drop_down_arrow")
        imgViewForDropDown.isUserInteractionEnabled = true
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imgViewForDropDown.frame.width + 10, height: imgViewForDropDown.frame.height))
        containerView.addSubview(imgViewForDropDown)
        
        cityField.inputTextField.rightView = containerView
        cityField.inputTextField.rightViewMode = .always
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCustomDropDownView))
        imgViewForDropDown.addGestureRecognizer(tapGesture)
        
        imgViewForDropDown.contentMode = .right
    }
    
    @objc func showCustomDropDownView() {
        if let dropDownView = customDropDownView {
            dropDownView.removeFromSuperview()
            customDropDownView = nil
        } else {
            dropDownView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            dropDownView.backgroundColor = .white
            dropDownView.layer.cornerRadius = 8
            dropDownView.layer.shadowColor = UIColor.black.cgColor
            dropDownView.layer.shadowOpacity = 0.5
            dropDownView.layer.shadowOffset = CGSize(width: 0, height: 1)
            dropDownView.layer.shadowRadius = 5
            dropDownView.clipsToBounds = false
            
            let options = ["Calgary", "Camrose", "Brooks"]
            
            for (index, option) in options.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(option, for: .normal)
                button.contentHorizontalAlignment = .left
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                button.setTitleColor(.black, for: .normal)
                button.setTitleColor(UIColor.appColor(LPColor.OccasionalPurple), for: .highlighted)
                button.addTarget(self, action: #selector(dropDownOptionSelected(_:)), for: .touchUpInside)
                button.frame = CGRect(x: 0, y: 44 + CGFloat(index) * 50, width: 200, height: 50)
                button.backgroundColor = .white
                button.setBackgroundImage(UIImage(color: UIColor.appColor(LPColor.VerySubtleGray), alpha: 0.25), for: .highlighted)
                dropDownView.addSubview(button)
            }
            
            let searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.placeholder = "Search City"
            searchBar.delegate = self
            searchBar.searchTextField.backgroundColor = .clear
            dropDownView.addSubview(searchBar)
            
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: dropDownView.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: dropDownView.leadingAnchor),
                searchBar.trailingAnchor.constraint(equalTo: dropDownView.trailingAnchor),
                searchBar.heightAnchor.constraint(equalToConstant: 44)
            ])
            
            let rect = cityField.convert(cityField.bounds, to: view)
            dropDownView.frame.origin = CGPoint(x: rect.maxX - dropDownView.frame.width, y: rect.maxY)
            view.addSubview(dropDownView)
            customDropDownView = dropDownView
        }
    }
    
    @objc func dropDownOptionSelected(_ sender: UIButton) {
        if let option = sender.title(for: .normal) {
            cityField.inputTextField.text = option
            cityField.inputTextField.sendActions(for: .editingChanged)
        }
        sender.superview?.removeFromSuperview()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let dropDownView = customDropDownView {
            let rect = cityField.convert(cityField.bounds, to: view)
            dropDownView.frame.origin = CGPoint(x: rect.maxX - dropDownView.frame.width, y: rect.maxY)
        }
    }
    
    func passwordCreated(_ password: String) {
        
        guard let firstName = firstNameField.inputTextField.text,
              let lastName = lastNameField.inputTextField.text,
              let email = emailField.inputTextField.text,
              let phone = phoneField.inputTextField.text,
              let address = addressField.inputTextField.text,
              let city = cityField.inputTextField.text else { return }
        
        Auth0Manager.shared.signup(email: email, password: password, firstName: firstName, lastName: lastName, phone: phone, address: address, city: city) { success, error in
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
        
        nextButton.isEnabled = allFieldsFilled
        nextButton.setBackgroundColor(allFieldsFilled && emailField.inputTextField.text!.isValidEmail ? UIColor.appColor(LPColor.OccasionalPurple) : UIColor.appColor(LPColor.DisabledGray), forState: .normal)
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
