//
//  DashboardMenuViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/03/04.
//

import UIKit

class DashboardMenuViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var profileInitialView: UIView!
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    // MARK: - @IBAction
    @IBAction func accountInformationButtonTapped(_ sender: Any) {
        coordinator?.goToAccountInformationVC()
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        coordinator?.goToChangePasswordVC()
    }
    
    @IBAction func myPurchasesButtonTapped(_ sender: Any) {
        coordinator?.goToMyPurchasesVC()
    }
    
    @IBAction func myListingsButtonTapped(_ sender: Any) {
        coordinator?.goToMyListingsVC()
    }
    
    @IBAction func notificationButtonTapped(_ sender: Any) {
        coordinator?.goToNotificationVC()
    }
    
    @IBAction func faqButtonTapped(_ sender: Any) {
        coordinator?.goToFAQVC()
    }
    
    @IBAction func contactUsButtonTapped(_ sender: Any) {
        coordinator?.goToContactUsVC()
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        Auth0Manager.shared.signOut()
        
        self.navigationController?.popToViewController(self.navigationController!.children[0], animated: true)
    }
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        changeNameAndPrefix()
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeNameAndPrefix()
        configureProfileView()
        
        setupNavigationBarWithExitButtonOnRight()
        // Do any additional setup after loading the view.
    }
    
    func changeNameAndPrefix() {
        guard let firstName = UserDefaults.standard.string(forKey: "firstName"),
              let lastName = UserDefaults.standard.string(forKey: "lastName") else { return }
        
        let prefixString = lastName.prefix(1)
        
        nameLabel.text = "\(firstName) \(lastName)"
        initialLabel.text = "\(prefixString)"
    }
    
    func configureProfileView() {
        profileInitialView.layer.cornerRadius = profileInitialView.layer.bounds.width / 2
        profileInitialView.clipsToBounds = true
    }
}
