//
//  CreatePasswordViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/14.
//

import UIKit

class CreatePasswordViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBAction func termsOfServiceTapped(_ sender: Any) {
        print("It's Working.. I think?")
    }
    
    @IBAction func privacyPolicyTapped(_ sender: Any) {
        print("Is it though?")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
    }
}
