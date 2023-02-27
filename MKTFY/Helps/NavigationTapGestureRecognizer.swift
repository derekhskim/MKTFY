//
//  NavigationTapGestureRecognizer.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/27.
//

import UIKit

class NavigationTapGestureRecognizer: UITapGestureRecognizer {
    var viewController: UIViewController?

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event!)

    }
}

