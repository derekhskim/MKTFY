//
//  ForgotPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/01.
//

import UIKit
import Auth0

class ForgotPasswordVerificationViewController: MainViewController, LoginStoryboard {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sentLabel: UILabel!
    
    // MARK: - @IBAction
    @IBAction func returnToEmailButtonTapped(_ sender: Any) {
        navigationController?.popToViewController(self.navigationController!.children[0], animated: true)
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
    }
}

// MARK: - Extension
// Determines where the back button should take the view controller to
extension ForgotPasswordVerificationViewController {
    @objc override func backButtonTapped() {
        self.navigationController?.popToViewController(self.navigationController!.children[1], animated: true)
    }
}
