//
//  Coordinator.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/27.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
