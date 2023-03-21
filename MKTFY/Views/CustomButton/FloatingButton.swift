//
//  FloatingButton.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-21.
//

import UIKit

class FloatingButton: UIButton {
    init(action: Selector, target: AnyObject) {
        super.init(frame: .zero)
        
        let image = UIImage(systemName: "plus.circle")
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Create Listing"
        configuration.image = image
        configuration.attributedTitle?.font = UIFont(name: "OpenSans-Bold", size: 14)
        configuration.attributedTitle?.foregroundColor = .white
        configuration.background.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
        configuration.imagePadding = 10
        configuration.image?.withTintColor(.white, renderingMode: .alwaysTemplate)
        configuration.cornerStyle = .capsule
        
        self.configuration = configuration

        self.translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

