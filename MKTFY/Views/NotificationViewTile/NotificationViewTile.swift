//
//  NotificationViewTile.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-20.
//

import UIKit

@IBDesignable
class NotificationViewTile: UITableViewCell {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var notificationTileView: UIView!
    @IBOutlet weak var textHoldingView: UIView!
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
            
            textHoldingView.backgroundColor = viewBackgroundColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        let nib = UINib(nibName: "NotificationViewTile", bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view?.frame = bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view!)
    }
}

