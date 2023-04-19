//
//  DashboardMenuViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/03/04.
//

import UIKit

class DashboardMenuViewController: MainViewController, DashboardStoryboard {
    
    // MARK: - Properties
    weak var coordinator: MainCoordinator?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var profileInitialView: UIView!
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var listingCountContainerView: UIView!
    @IBOutlet weak var listingCountLabel: UILabel!
    @IBOutlet weak var notificationsCountContainerView: UIView!
    @IBOutlet weak var notificationsCountLabel: UILabel!
    
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
        GetListingsAndNotificationsCounts()
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetListingsAndNotificationsCounts()
        
        listingCountContainerView.isHidden = true
        listingCountLabel.isHidden = true
        notificationsCountContainerView.isHidden = true
        notificationsCountLabel.isHidden = true
        
        changeNameAndPrefix()
        configureProfileView()
        configureContainerView()
        
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
        profileInitialView.clipsToBounds = false
        
        profileInitialView.layer.shadowColor = UIColor.black.cgColor
        profileInitialView.layer.shadowOffset = CGSize(width: 0, height: 4)
        profileInitialView.layer.shadowOpacity = 0.25
        profileInitialView.layer.shadowRadius = 6
    }
    
    func configureContainerView() {
        listingCountContainerView.layer.cornerRadius = 10
        notificationsCountContainerView.layer.cornerRadius = 10
    }
    
    func GetListingsAndNotificationsCounts() {
        let getListingsAndNotificationsCountsEndpoint = GetListingsAndNotificationsCountsEndpoint()
        NetworkManager.shared.request(endpoint: getListingsAndNotificationsCountsEndpoint) { (result: Result<ListingsAndNotificationsCountResponse, Error>) in
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.listingCountLabel.text = "\(response.pendingListings)"
                    self.notificationsCountLabel.text = "\(response.unreadNotifications)"
                    
                    UIUtility.updateVisibility(response.pendingListings, threshold: 0, label: self.listingCountLabel, containerView: self.listingCountContainerView)
                    UIUtility.updateVisibility(response.unreadNotifications, threshold: 0, label: self.notificationsCountLabel, containerView: self.notificationsCountContainerView)
                }
                
                print("Retrieved successfully: \(response)")
            case .failure(let error):
                print("Failed to retrieve: \(error.localizedDescription)")
            }
            
        }
    }
}
