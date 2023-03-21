//
//  NotificationViewTile.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-20.
//

import UIKit

@IBDesignable
class NotificationViewTile: LPView {
    
    var view: UIView!
    
    // MARK: - @IBOutlet
    @IBOutlet weak var notificationTileView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - @IBInspectable
    @IBInspectable var title: String = "Title" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var date: String = "Date" {
        didSet {
            dateLabel.text = date
        }
    }
    
    @IBInspectable var viewBackgroundColor: UIColor = .white {
        didSet {
            notificationTileView.backgroundColor = viewBackgroundColor
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ListingViewTile", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
}

