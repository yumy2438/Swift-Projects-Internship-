//
//  WeatherCell.swift
//  weatherForecastAPI
//
//  Created by esra.yildiz on 12.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell
{
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var weatherExplanation: UILabel!
    
    @IBOutlet weak var weatherTemperature: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
