//
//  AnswerTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-14.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var answerTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        answerTextView.isEditable = false
        answerTextView.isScrollEnabled = false
    }
}
