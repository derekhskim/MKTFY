//
//  AccountInformationViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/03/06.
//

import UIKit
import Auth0

class AccountInformationViewController: UIViewController, DashboardStoryboard {
    
    let auth0Manager = Auth0Manager()
    
    @IBOutlet weak var firstNameView: TextFieldWithError!
    @IBOutlet weak var lastNameView: TextFieldWithError!
    @IBOutlet weak var emailView: TextFieldWithError!
    @IBOutlet weak var phoneView: TextFieldWithError!
    @IBOutlet weak var addressView: TextFieldWithError!
    @IBOutlet weak var cityView: TextFieldWithError!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameView.inputTextField.text = "Derek"
        lastNameView.inputTextField.text = "Kim"
        emailView.inputTextField.text = "treasure3210@gmail.com"
        phoneView.inputTextField.text = "587-973-5454"
        addressView.inputTextField.text = "370 Quarry Way SE"
        cityView.inputTextField.text = "Calgary"
        // Do any additional setup after loading the view.
    }
}
