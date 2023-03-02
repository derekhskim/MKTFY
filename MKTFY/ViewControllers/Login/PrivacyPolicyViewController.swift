//
//  PrivacyPolicyViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/03/01.
//

import UIKit

class PrivacyPolicyViewController: UIViewController, LoginStoryboard {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
    }
}
