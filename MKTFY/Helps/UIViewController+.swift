//
//  UIViewController+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import Foundation
import UIKit

extension UIViewController {
    static func storyboardInstance(storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self))
    }
}
