//
//  MainViewController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/06.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = LoginViewController.storyboardInstance(storyboardName: "Login")
        let nv = MainNavigationController(rootViewController: vc)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.windows.first?.rootViewController = nv
        }
        
    }
}
