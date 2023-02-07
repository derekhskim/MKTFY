//
//  CreateAccountViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/06.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Controls the back button's action and style
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.appColor(LPColor.LightestPurple)
        self.navigationItem.leftBarButtonItem = backButton
        
        view.backgroundColor = UIColor.appColor(LPColor.VoidWhite)
        backgroundView.layer.cornerRadius = CGFloat(20)
        backgroundView.clipsToBounds = true
    }
    
}

// Determines where the back button should take the view controller to
extension CreateAccountViewController {
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
