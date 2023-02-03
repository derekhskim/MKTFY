//
//  MainNavigationController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/01.
//

import UIKit

class NoNavBarViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
                        
        // Do any additional setup after loading the view.
    }
}
