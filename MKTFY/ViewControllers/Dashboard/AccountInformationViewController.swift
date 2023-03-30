//
//  AccountInformationViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/03/06.
//

import UIKit

class AccountInformationViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var firstNameView: TextFieldWithError!
    @IBOutlet weak var lastNameView: TextFieldWithError!
    @IBOutlet weak var emailView: TextFieldWithError!
    @IBOutlet weak var phoneView: TextFieldWithError!
    @IBOutlet weak var addressView: TextFieldWithError!
    @IBOutlet weak var cityView: TextFieldWithError!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupNavigationBarWithSaveButtonOnRight()
        
        fetchUsers()
        
        emailView.isUserInteractionEnabled = false
        emailView.inputTextField.textColor = UIColor.appColor(LPColor.TextGray40)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Function
    override func fetchUsers() {
        NetworkManager.shared.getUsers { result in
            switch result {
            case .success(let user):
                print("User: \(user)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        guard let firstName = UserDefaults.standard.string(forKey: "firstName"),
              let lastName = UserDefaults.standard.string(forKey: "lastName"),
              let email = UserDefaults.standard.string(forKey: "email"),
              let phone = UserDefaults.standard.string(forKey: "phone"),
              let address = UserDefaults.standard.string(forKey: "address"),
              let city = UserDefaults.standard.string(forKey: "city") else { return }
        
        firstNameView.inputTextField.text = firstName
        lastNameView.inputTextField.text = lastName
        emailView.inputTextField.text = email
        phoneView.inputTextField.text = phone
        addressView.inputTextField.text = address
        cityView.inputTextField.text = city
    }
    
    func setupNavigationBarWithSaveButtonOnRight() {
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        saveButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appColor(LPColor.GrayButtonGray) as Any, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        saveButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appColor(LPColor.GrayButtonGray) as Any], for: .highlighted)
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func saveButtonTapped() {
        guard let userId = UserDefaults.standard.string(forKey: "userId"),
              let firstName = firstNameView.inputTextField.text,
              let lastName = lastNameView.inputTextField.text,
              let email = emailView.inputTextField.text,
              let phone = phoneView.inputTextField.text,
              let address = addressView.inputTextField.text,
              let city = cityView.inputTextField.text else { return }
        
        let user = User(id: userId, firstName: firstName, lastName: lastName, email: email, phone: phone, address: address, city: city)
        
        NetworkManager.shared.updateUsers(user: user) { result in
            switch result {
            case .success(_):
                print("User updated successfully: \(user)")
                
                UserDefaults.standard.set(user.firstName, forKey: "firstName")
                UserDefaults.standard.set(user.lastName, forKey: "lastName")
                UserDefaults.standard.set(user.email, forKey: "email")
                UserDefaults.standard.set(user.phone, forKey: "phone")
                UserDefaults.standard.set(user.address, forKey: "address")
                UserDefaults.standard.set(user.city, forKey: "city")
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
            case .failure(let error):
                print("Error updating user: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    self.showAlert(title: "Something went wrong", message: "Account inforamtion could not be saved. Please try again.", purpleButtonTitle: "OK", whiteButtonTitle: "Try Again")
                }
                
            }
        }
    }
}
