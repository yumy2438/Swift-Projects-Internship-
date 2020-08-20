//
//  messageCell.swift
//  messageApp
//
//  Created by esra.yildiz on 20.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TakenMessageCell: UITableViewCell {

    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var fromName: UILabel!
    @IBOutlet weak var addPersonButtonClicked: UIButton!
    @IBOutlet weak var replyButtonClicked: UIButton!
    
    @IBOutlet weak var readButton: UIButton!
    
    var tickNumber = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageText.isEditable = false
    }
}
