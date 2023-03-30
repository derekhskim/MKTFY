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
    let networkManager = NetworkManager()
    
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
}
