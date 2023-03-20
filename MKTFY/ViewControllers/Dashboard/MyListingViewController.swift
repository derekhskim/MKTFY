//
//  MyListingViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class MyListingViewController: MainViewController, DashboardStoryboard {

    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        // Do any additional setup after loading the view.
    }
}
