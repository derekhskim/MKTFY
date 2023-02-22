//
//  ResetPasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/20.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
    }
    
    
}

// Determines where the back button should take the view controller to
extension ResetPasswordViewController {
    @objc override func backButtonTapped() {
        self.navigationController?.popToViewController(self.navigationController!.children[1], animated: true)
    }
}

