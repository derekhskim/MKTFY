//
//  MainNavigationController.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/01.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.appColor(LPColor.OccasionalPurple)!]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
                        
        // Do any additional setup after loading the view.
    }
}
