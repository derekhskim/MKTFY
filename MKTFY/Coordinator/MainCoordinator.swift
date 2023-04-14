//
//  MainCoordinator.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/27.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.appColor(LPColor.OccasionalPurple)!]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
    }
    
    // MARK: - Login
    func start() {
//        let vc = DashboardViewController.instantiate()
        let vc = LoginViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToForgotPasswordVC() {
        let vc = ForgotPasswordViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToLoadingConfirmationVC() {
        let vc = LoadingConfirmationViewcontroller.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToForgotPasswordVerificationVC() {
        let vc = ForgotPasswordVerificationViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCreateAccountVC() {
        let vc = CreateAccountViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCreatePasswordVC() {
        let vc = CreatePasswordViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToTermsOfServiceVC() {
        let vc = TermsOfServiceViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToPrivacyPolicyVC() {
        let vc = PrivacyPolicyViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToEmailVerifiationSentVC() {
        let vc = EmailVerificationSentViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - Dashboard
    func goToDashboardVC() {
        let vc = DashboardViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToDashboardMenuVC() {
        let vc = DashboardMenuViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - Dashboard Menu
    func goToAccountInformationVC() {
        let vc = AccountInformationViewController.instantiate()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCreateListingVC() {
        let vc = CreateListingViewController.instantiate()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func goToFAQVC() {
        let vc = FAQViewController.instantiate()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func goToFAQSpecificVC() {
        let vc = FAQSpecificViewController.instantiate()
        self.navigationController.present(vc, animated: true)
    }
    
    func goToContactUsVC() {
        let vc = ContactUsViewController.instantiate()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func goToNotificationVC() {
        let vc = NotificationViewController.instantiate()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func goToChangePasswordVC() {
        let vc = ChangePasswordViewController.instantiate()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMyPurchasesVC() {
        let vc = MyPurchasesViewController.instantiate()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMyListingsVC() {
        let vc = MyListingViewController.instantiate()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func goToProductDetailsVC(listingId: String) {
        let vc = ProductDetailsViewController.instantiate()
        vc.coordinator = self
        vc.listingId = listingId
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCheckoutVC(listingResponse: ListingResponse) {
        let vc = CheckoutViewController.instantiate()
        vc.coordinator = self
        vc.listingResponse = listingResponse
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func goToPickupInformationVC(listingResponse: ListingResponse) {
        let vc = PickupInformationViewController.instantiate()
        vc.coordinator = self
        vc.listingResponse = listingResponse
        self.navigationController.pushViewController(vc, animated: true)
    }
}
