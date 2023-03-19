//
//  FAQ1ViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-18.
//

import UIKit

class FAQ1ViewController: MainViewController, DashboardStoryboard {

    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundView(view: backgroundView)
        setupNavigationBarWithBackButton()

        // Do any additional setup after loading the view.
    }
}
