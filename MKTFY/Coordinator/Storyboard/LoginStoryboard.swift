//
//  Storyboard.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/27.
//

import UIKit

protocol LoginStoryboard {
    static func instantiate() -> Self
}

extension LoginStoryboard where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
