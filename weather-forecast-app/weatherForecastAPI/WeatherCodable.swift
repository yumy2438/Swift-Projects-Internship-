//
//  WeatherCodable.swift
//  weatherForecastAPI
//
//  Created by esra.yildiz on 16.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation
public class WeatherCodable
{
    struct Json: Decodable
    {
        let city: City
        let list: [List]
    }
    
    struct City: Decodable
    {
        let name: String
    }
    
    struct List: Decodable {
        let temp: Temp
        let weather: [Weather]
        let pressure: Double
        let humidity: Int
    }
    struct Temp: Decodable {
        let day: Double
        let night: Double
        let morn: Double
        let eve: Double
    }
    struct Weather: Decodable {
        let description: String
        let icon: String
    }
}
