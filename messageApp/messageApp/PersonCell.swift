//
//  PersonCell.swift
//  messageApp
//
//  Created by esra.yildiz on 19.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    @IBOutlet weak var personNameSurname: UILabel!
    @IBOutlet weak var personEmail: UILabel!
    @IBOutlet weak var personImage: UIImageView!
    
    @IBOutlet weak var takeMessageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        personNameSurname.isUserInteractionEnabled = false
        personEmail.isUserInteractionEnabled = false
        personImage.isUserInteractionEnabled = false
        
    }
    
    
}
