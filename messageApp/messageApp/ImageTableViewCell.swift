//
//  ImageTableViewCell.swift
//  messageApp
//
//  Created by esra.yildiz on 16.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var imageLeadingConstraint: NSLayoutConstraint!
    var isFriend = false
    var widthOfTheTableView: CGFloat?
    override func awakeFromNib() {
        super.awakeFromNib()
        if isFriend
        {
            if let widthOfTheTableView = widthOfTheTableView
            {
//                let imageWidth = photoImageView.frame.size.width
//                imageLeadingConstraint.constant = widthOfTheTableView - imageWidth
            }
        }
        else
        {
            
        }
    }
    
}
