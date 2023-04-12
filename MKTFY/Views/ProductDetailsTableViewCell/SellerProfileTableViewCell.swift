//
//  SellerProfileTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import UIKit

class SellerProfileTableViewCell: UITableViewCell {
    
    var listingResponse: ListingResponse?
    
    // MARK: - @IBOutlet
    @IBOutlet weak var profileHoldingView: UIView!
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var listingCountLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureProfileHoldingView()
        configureSellerProfile()
        changeNameAndPrefix()
        selectionStyle = .none
    }
    
    func configureSellerProfile() {
        tagImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        guard let sellerCount = listingResponse?.sellerListingCount else { return }
        let sellerCountString = "\(sellerCount)"
        
        let attributedSellerCount = NSMutableAttributedString(string: sellerCountString, attributes: [
            NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.appColor(LPColor.TextGray) ?? UIColor.gray
        ])
        
        let listingString = " Listing"
        let attributedListingString = NSAttributedString(string: listingString, attributes: [
            NSAttributedString.Key.font: UIFont(name: "OpenSans-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.appColor(LPColor.TextGray) ?? UIColor.gray
        ])
        
        attributedSellerCount.append(attributedListingString)
        listingCountLabel.attributedText = attributedSellerCount
    }
    
    func changeNameAndPrefix() {
        guard let firstName = listingResponse?.sellerProfile?.firstName,
              let lastName = listingResponse?.sellerProfile?.lastName else { return }
        
        let prefixString = lastName.prefix(1)
        
        nameLabel.text = "\(firstName) \(lastName)"
        initialLabel.text = "\(prefixString)"
    }
    
    func configureProfileHoldingView() {
        profileHoldingView.layer.cornerRadius = profileHoldingView.layer.bounds.width / 2
        profileHoldingView.clipsToBounds = false
        
        profileHoldingView.layer.shadowColor = UIColor.black.cgColor
        profileHoldingView.layer.shadowOffset = CGSize(width: 0, height: 4)
        profileHoldingView.layer.shadowOpacity = 0.25
        profileHoldingView.layer.shadowRadius = 6
    }
    
}
