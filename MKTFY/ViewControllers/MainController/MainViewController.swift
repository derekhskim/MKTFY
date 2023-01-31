//
//  MainViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import UIKit

class MainViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let vc = LoginViewController.storyboardInstance(storyboardName: "LoginScreen")
        UIApplication.shared.windows.first?.rootViewController = vc
    }
    
}
