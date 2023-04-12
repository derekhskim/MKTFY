//
//  UIUtility.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-12.
//

import UIKit

struct UIUtility {
    static func updateVisibility<T: Comparable>(_ value: T, threshold: T, label: UILabel, containerView: UIView) {
        let shouldHide = value <= threshold
        label.isHidden = shouldHide
        containerView.isHidden = shouldHide
    }
    
    @discardableResult
    static func configure<T>(_ value: T, using closure: (inout T) throws -> Void) rethrows -> T {
        var value = value
        try closure(&value)
        return value
    }
}
