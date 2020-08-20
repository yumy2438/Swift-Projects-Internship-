//
//  FriendCell.swift
//  messageApp
//
//  Created by esra.yildiz on 26.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var messageView: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.messageView.sizeToFit()
    }

}
