//
//  SendingMessageCell.swift
//  
//
//  Created by esra.yildiz on 22.07.2018.
//

import UIKit

class SendingMessageCell: UITableViewCell {
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        message.isEditable = false
    }

}
