//
//  DashboardViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/21.
//

import UIKit

class DashboardViewController: MainViewController, DashboardStoryboard {
    
    weak var coordinator: MainCoordinator?

    // MARK: - @IBOutlet
    @IBOutlet weak var navigationWhiteBackgroundView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var searchImageView: UIImageView!
    
    // MARK: - @IBAction
    
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationWhiteBackgroundView.layer.cornerRadius = 10
        navigationWhiteBackgroundView.clipsToBounds = true
        
        menuButton()
        
    }
    
}

// MARK: - Extension
extension DashboardViewController {
    
    func menuButton() {
        let menuTapped = UITapGestureRecognizer(target: self, action: #selector(menuButtonTapped))
        menuImageView.addGestureRecognizer(menuTapped)
        menuImageView.isUserInteractionEnabled = true
    }
    
    @objc func menuButtonTapped() {
        let vc = DashboardMenuViewController.storyboardInstance(storyboardName: "Dashboard") as! DashboardMenuViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchButtonTapped() {
        
    }
}
