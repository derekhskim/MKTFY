//
//  MyListingViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-19.
//

import UIKit

class MyListingViewController: MainViewController, DashboardStoryboard {

    weak var coordinator: MainCoordinator?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarWithBackButton()
        setupBackgroundView(view: backgroundView)
        
        floatingButton()
    }
    
    func floatingButton() {
        let floatingButton = FloatingButton(action: #selector(floatingButtonTapped), target: self)
        view.addSubview(floatingButton)
        
        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: 165),
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
            floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func floatingButtonTapped() {
        coordinator?.goToCreateListingVC()
    }
}
