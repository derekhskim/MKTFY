//
//  MainCoordinator.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/27.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LoginViewController.instantiate()
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
