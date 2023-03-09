//
//  TermsOfServiceViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/03/01.
//

import UIKit

class TermsOfServiceViewController: MainViewController, LoginStoryboard {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: - @IBAction
    @IBAction func acceptButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
    }
}
