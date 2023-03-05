//
//  UIViewController+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import Foundation
import UIKit

extension UIViewController {
    static func storyboardInstance(storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self))
    }
}

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
    
    func setupNavigationBarWithMenuButton() {
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "menu_bar"), style: .plain, target: self, action: #selector(menuButtonTapped))
        menuButton.tintColor = UIColor.appColor(LPColor.OccasionalPurple)
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    @objc func menuButtonTapped() {
        let vc = DashboardMenuViewController.storyboardInstance(storyboardName: "Dashboard") as! DashboardMenuViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIViewController {
    func setupBackgroundView(view: UIView) {
        let backgroundView = view
        backgroundView.layer.cornerRadius = CGFloat(20)
        backgroundView.clipsToBounds = true
    }
}

// Show Alert
extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
