//
//  NoteCollectionViewCell.swift
//  notebookApp
//
//  Created by esra.yildiz on 6.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        noteLabel.layer.masksToBounds = false
        noteLabel.layer.shadowColor = UIColor.black.cgColor
        noteLabel.layer.shadowOpacity = 5
        noteLabel.layer.shadowOffset = CGSize(width: -3, height: 3)
        noteLabel.layer.shadowRadius = 2
        noteLabel.sizeToFit()
    }
    
}
