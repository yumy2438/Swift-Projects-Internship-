//
//  PhotoTableViewCell.swift
//  
//
//  Created by esra.yildiz on 16.08.2018.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet weak var constraintForLeading: NSLayoutConstraint!
    var isFriend = false
    var widthOfTheTableView: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isFriend
        {
            if let widthOfTheTableView = widthOfTheTableView
            {
                let widthOfTheImage = photoImage.frame.size.width
                constraintForLeading.constant = widthOfTheTableView - widthOfTheImage
            }
        }
        else
        {
            constraintForLeading.constant = 0
        }

    }
    
}
