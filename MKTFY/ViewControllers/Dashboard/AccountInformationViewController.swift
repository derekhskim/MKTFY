//
//  AccountInformationViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/03/06.
//

import UIKit
import Auth0

class AccountInformationViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var firstNameView: TextFieldWithError!
    @IBOutlet weak var lastNameView: TextFieldWithError!
    @IBOutlet weak var emailView: TextFieldWithError!
    @IBOutlet weak var phoneView: TextFieldWithError!
    @IBOutlet weak var addressView: TextFieldWithError!
    @IBOutlet weak var cityView: TextFieldWithError!
    
    // MARK: - @IBAction
    // TODO: add PUT method to save button to update a user
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupNavigationBarWithSaveButtonOnRight()
        
        fetchUsers()
        
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
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Function
    func fetchUsers() {
        NetworkManager.shared.getUsers { result in
            switch result {
            case .success(let user):
                print("User: \(user)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
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
        
        let encodedUserId = userId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        
        let user = User(id: encodedUserId!, firstName: firstName, lastName: lastName, email: email, phone: phone, address: address, city: city)
        
        NetworkManager.shared.updateUsers(user: user) { result in
            switch result {
            case .success(let updatedUser):
                print("User updated successfully: \(updatedUser)")
                
                UserDefaults.standard.set(updatedUser.firstName, forKey: "firstName")
                UserDefaults.standard.set(updatedUser.lastName, forKey: "lastName")
                UserDefaults.standard.set(updatedUser.email, forKey: "email")
                UserDefaults.standard.set(updatedUser.phone, forKey: "phone")
                UserDefaults.standard.set(updatedUser.address, forKey: "address")
                UserDefaults.standard.set(updatedUser.city, forKey: "city")
            case .failure(let error):
                print("Error updating user: \(error.localizedDescription)")
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
