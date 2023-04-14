//
//  UIViewController+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import Foundation
import UIKit
import Auth0

// MARK: - Functionality
extension UIViewController {
    static func storyboardInstance(storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self))
    }
}

// MARK: - Navigation Bar Setup
extension UIViewController {
    func setupNavigationBarWithBackButton() {
        // Controls the back button's action and style
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.appColor(LPColor.LightestPurple)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    // Determines where the back button should take the view controller to
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupNavigationBarWithExitButtonOnRight() {
        let exitButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(exitButtonTapped))
        exitButton.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = exitButton
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    @objc func exitButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupBackgroundView(view: UIView) {
        let backgroundView = view
        backgroundView.layer.cornerRadius = CGFloat(20)
        backgroundView.clipsToBounds = true
    }
}

// MARK: - Show Custom Alert
extension UIViewController {
    func showAlert(title: String, message: String, purpleButtonTitle: String, whiteButtonTitle: String, purpleButtonAction: @escaping () -> Void, whiteButtonAction: @escaping () -> Void) {
        let customAlert = DKCustomAlertViewController(title: title, description: message, purpleButtonTitle: purpleButtonTitle, whiteButtonTitle: whiteButtonTitle, purpleButtonAction: purpleButtonAction, whiteButtonAction: whiteButtonAction)
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.modalTransitionStyle = .crossDissolve
        self.present(customAlert, animated: true, completion: nil)
    }
}

