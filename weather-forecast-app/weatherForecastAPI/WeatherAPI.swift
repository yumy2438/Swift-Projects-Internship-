//
//  WeatherAPI.swift
//  weatherForecastAPI
//
//  Created by esra.yildiz on 12.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation
import Alamofire

let APIKey="41a47c0c4d7d86694bd472f51e33f937"
let service="http://api.openweathermap.org/data/2.5"

public class WeatherAPI
{

    class func forecastMethod(cityName: String, day: String) -> String
    {
        let method="/forecast"
        let cityInfo="/daily?q="+cityName
        let dayInfo="&cnt="+day
        let APIInfo="&units=metric&APPID="+APIKey
        return (service+method+cityInfo+dayInfo+APIInfo)
    }
    
    class func getForecast(url: URL, completion: @escaping (WeatherCodable.Json) -> ())
    {
        var weatherList: WeatherCodable.Json!
        Alamofire.request(url).responseJSON { (response) in
            if let error = response.error
            {
                print(error.localizedDescription)
            }
            else
            {
                let jsonDict = response.data
                let json = try! JSONDecoder().decode(WeatherCodable.Json.self, from: jsonDict!)
                weatherList = json
                completion(weatherList)
            }
        }
    }
}

