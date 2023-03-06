//
//  DashboardMenuViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/03/04.
//

import UIKit

class DashboardMenuViewController: UIViewController, LoginStoryboard {

    let coordinator: MainCoordinator?
    
    @IBOutlet weak var profileInitialView: UIView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBAction func signOutButtonTapped(_ sender: Any) {
        Auth0Manager.shared.signOut()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithExitButtonOnRight()
        
        profileInitialView.layer.cornerRadius = profileInitialView.layer.bounds.width / 2
        profileInitialView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
}
