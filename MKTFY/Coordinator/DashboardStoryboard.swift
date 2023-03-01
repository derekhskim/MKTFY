//
//  DashboardStoryboard.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/28.
//

import Foundation
import UIKit

protocol DashboardStoryboard {
    static func instantiate() -> Self
}

extension DashboardStoryboard where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Dashboard", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
