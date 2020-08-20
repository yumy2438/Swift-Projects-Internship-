//
//  WeatherObject.swift
//  weatherForecastAPI
//
//  Created by esra.yildiz on 17.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation

class WeatherObject: NSObject, NSCoding
{
    var city:String
    var day:String
    init(city: String, day: String ) {
        self.city = city
        self.day = day
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: "city")
        aCoder.encode(day, forKey: "day")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let city = aDecoder.decodeObject(forKey: "city") as! String
        let day = aDecoder.decodeObject(forKey: "day") as! String
        self.init(city: city, day: day)
    }
    
}
