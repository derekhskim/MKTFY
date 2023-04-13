//
//  PickupInformationViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-12.
//

import UIKit
import MessageUI

class PickupInformationViewController: MainViewController, DashboardStoryboard, MFMailComposeViewControllerDelegate {
    
    weak var coordinator: MainCoordinator?
    var listingResponse: ListingResponse?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var sellerInformationContainerView: UIView!
    @IBOutlet weak var sellerProfileContainerView: UIView!
    @IBOutlet weak var sellerProfileInitialLabel: UILabel!
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var sellerPhoneNumber: UILabel!
    @IBOutlet weak var sellerAddressLabel: UILabel!
    @IBOutlet weak var contactSellerButton: UIButton!
    
    // MARK: - @IBAction
    @IBAction func contactSellerButtonTapped(_ sender: Any) {
        guard let email = listingResponse?.sellerProfile?.email else { return }
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setToRecipients([email])
            mailComposeViewController.mailComposeDelegate = self
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                self.showAlert(title: "Email error!", message: "Unable to send email. Please check your email settings and try again.", purpleButtonTitle: "OK", whiteButtonTitle: "Cancel")
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        coordinator?.goToLoadingConfirmationVC()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            self.coordinator?.goToDashboardVC()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureContactSellerButton()
    }
    
    func configureContactSellerButton() {
        let normalBackgroundColor = UIColor.appColor(LPColor.LightestPurple).withAlphaComponent(0.2)
        let highlightedBackgroundColor = UIColor.appColor(LPColor.LightestPurple).withAlphaComponent(0.4)
        
        contactSellerButton.layer.cornerRadius = 20
        contactSellerButton.clipsToBounds = true
        contactSellerButton.layer.masksToBounds = true
        contactSellerButton.setTitleColor(UIColor.appColor(LPColor.LightestPurple), for: .normal)
        
        contactSellerButton.backgroundColor = normalBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundView(view: backgroundView)
        setupNavigationBarWithBackButton()
        
        configureProfileView()
        configureSellerProfileView()
        
    }
    
    func configureProfileView() {
        productNameLabel.text = listingResponse?.productName
        
        if let firstImageURL = listingResponse?.images.first {
            productImageView.loadImage(from: URL(string: firstImageURL))
        } else {
            productImageView.image = UIImage(named: "no-image")
        }
        
        productImageView.layer.cornerRadius = productImageView.bounds.width / 2
    }
    
    func configureSellerProfileView() {
        sellerInformationContainerView.layer.cornerRadius = 20
        sellerProfileContainerView.layer.cornerRadius = sellerProfileContainerView.bounds.width / 2
        
        sellerProfileContainerView.clipsToBounds = false
        
        sellerProfileContainerView.layer.shadowColor = UIColor.black.cgColor
        sellerProfileContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        sellerProfileContainerView.layer.shadowOpacity = 0.25
        sellerProfileContainerView.layer.shadowRadius = 6
        
        guard let prefixString = listingResponse?.sellerProfile?.lastName?.prefix(1) else { return }
        sellerProfileInitialLabel.text = String(prefixString)
        
        guard let firstName = listingResponse?.sellerProfile?.firstName,
              let lastName = listingResponse?.sellerProfile?.lastName,
              let phoneNumber = listingResponse?.sellerProfile?.phone,
              let address = listingResponse?.sellerProfile?.address,
              let city = listingResponse?.sellerProfile?.city else { return }
        
        sellerName.text = "\(firstName) \(lastName)"
        sellerPhoneNumber.text = phoneNumber
        
        sellerAddressLabel.text = "Please pick up your purchased item at \(address), \(city), Alberta"
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
