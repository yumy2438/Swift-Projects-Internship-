//
//  UserDefaultsClass.swift
//  weatherForecastAPI
//
//  Created by esra.yildiz on 18.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation

public class UserDefaultsClass
{
    
    class func setArray(weatherArray:[WeatherObject]) -> Void
    {
        let encodedArray = NSKeyedArchiver.archivedData(withRootObject: weatherArray)
        UserDefaults.standard.set(encodedArray, forKey: "weather")
        UserDefaults.standard.synchronize()
    }
    
    class func getArray() -> [WeatherObject]
    {
        let encodedData = UserDefaults.standard.object(forKey: "weather") as! Data
        let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as! [WeatherObject]
        return decodedArray
    }

    class func isEmpty() -> Bool
    {
        return getArray().isEmpty
    }
    
    class func removeAt(index: Int) -> Void
    {
        var decodedArray = getArray()
        decodedArray.remove(at: index)
        setArray(weatherArray: decodedArray)
    }
    
    class func insertObject(weatherObject: WeatherObject) -> Void
    {
        var decodedArray = getArray()
        let isThereAnyCityIndex = Constants.isThereAnyCity(city: weatherObject.city, array: decodedArray)
        if isThereAnyCityIndex == nil
        {
            decodedArray.append(weatherObject)
        }
        else
        {
            decodedArray[isThereAnyCityIndex!] = weatherObject
        }
        setArray(weatherArray: decodedArray)
    }
}
