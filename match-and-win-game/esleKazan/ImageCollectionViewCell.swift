//
//  ImageCollectionViewCell.swift
//  esleKazan
//
//  Created by esra.yildiz on 9.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var animalImage: UIImageView!
    var indexList = [Int]()
    var chosenIndex: Int!
    var lastChosenImage: UIImage?
    
    override func awakeFromNib() {
        animalImage.image = UIImage(named: "maviEkran.jpg")
    }

}
