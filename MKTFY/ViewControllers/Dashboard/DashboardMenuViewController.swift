//
//  DashboardMenuViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/03/04.
//

import UIKit

class DashboardMenuViewController: MainViewController, DashboardStoryboard {
        
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var profileInitialView: UIView!
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func accountInformationButtonTapped(_ sender: Any) {
        coordinator?.goToAccountInformationVC()
    }
    
    
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
//        Auth0Manager.shared.resetPassword(email: <#T##String#>)
    }
    
    @IBAction func myPurchasesButtonTapped(_ sender: Any) {
        print("My Purchases button tapped!")
    }
    
    @IBAction func myListingsButtonTapped(_ sender: Any) {
        print("My Listings button tapped!")
    }
    
    @IBAction func notificationButtonTapped(_ sender: Any) {
        print("Notification button tapped!")
    }
    
    
    @IBAction func faqButtonTapped(_ sender: Any) {
        coordinator?.goToFAQVC()
    }
    
    @IBAction func contactUsButtonTapped(_ sender: Any) {
        coordinator?.goToContactUsVC()
    }
    
    @IBOutlet weak var signOutButton: UIButton!
    @IBAction func signOutButtonTapped(_ sender: Any) {
        Auth0Manager.shared.signOut()
        
        self.navigationController?.popToViewController(self.navigationController!.children[0], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithExitButtonOnRight()
        
        profileInitialView.layer.cornerRadius = profileInitialView.layer.bounds.width / 2
        profileInitialView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
}
