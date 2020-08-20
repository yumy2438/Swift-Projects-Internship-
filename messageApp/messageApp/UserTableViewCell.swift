//
//  UserTableViewCell.swift
//  messageApp
//
//  Created by esra.yildiz on 15.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var userText: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var isFriend = false
    var widthOfTheScreen: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isFriend
        {
            if let widthOfTheScreen = widthOfTheScreen
            {
                let widthOfTheUserText = userText.layer.frame.width
                leadingConstraint.constant = CGFloat(widthOfTheScreen - 12-widthOfTheUserText)
            }
            userText.textAlignment = .left
            userText.backgroundColor = UIColor.red
        }
        else
        {
            leadingConstraint.constant = 12
            userText.textAlignment = .left
            userText.backgroundColor = UIColor.green
        }
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
