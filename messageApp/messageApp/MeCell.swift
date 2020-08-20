//
//  meCell.swift
//  
//
//  Created by esra.yildiz on 26.07.2018.
//

import UIKit

class MeCell: UITableViewCell
{
    @IBOutlet weak var messageView: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.messageView.sizeToFit()
    }
}
