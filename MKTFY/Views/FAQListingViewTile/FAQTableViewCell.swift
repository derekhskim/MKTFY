//
//  FAQTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-14.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var faqQuestionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
