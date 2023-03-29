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
        
        // TODO: - call getUsers and assign data to each textfields
//        networkManager.getUsers()
        
        firstNameView.inputTextField.text = "Derek"
        lastNameView.inputTextField.text = "Kim"
        emailView.inputTextField.text = "treasure3210@gmail.com"
        phoneView.inputTextField.text = "587-973-5454"
        addressView.inputTextField.text = "370 Quarry Way SE"
        cityView.inputTextField.text = "Calgary"
        // Do any additional setup after loading the view.
    }
}
