//
//  PrivacyPolicyViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/03/01.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupBackgroundView(view: backgroundView)
    }
}
