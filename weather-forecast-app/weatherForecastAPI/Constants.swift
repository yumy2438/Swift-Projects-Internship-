//
//  Constants.swift
//  weatherForecastAPI
//
//  Created by esra.yildiz on 17.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation
class Constants
{
    let turkeyCityList = ["Adana","Adiyaman","Agri","Aksaray","Amasya","Ankara","Antalya","Artvin","Aydin","Balikesir","Bartin","Batman","Bayburt","Bilecik","Bingol","Bitlis","Bolu","Burdur","Bursa","Canakkale","Corum","Denizli","Diyarbakir","Duzce","Edirne","Elazig","Erzincan","Erzurum","Eskisehir","Gaziantep","Giresun","Hakkari","Hatay","Igdir","Isparta","Istanbul","Izmir","Kahramanmaras","Karabuk","Karaman","Kars","Kastamonu","Kayseri","Kilis","Kirikkale","Kirklareli","Kirsehir","Kocaeli","Konya","Kutahya","Malatya","Manisa","Mardin","Mersin","Mugla","Mus","Nevsehir","Nigde","Ordu","Osmaniye","Rize","Sakarya","Samsun","Sanliurfa","Siirt","Sinop","Sirnak","Sivas","Tekirdag","Tokat","Trabzon","Tunceli","Usak","Van","Yalova","Yozgat","Zonguldak"]
    
    let dayList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"]
    
    class func isThereAnyCity(city: String, array: [WeatherObject]) -> Int?
    {
        var index = 0
        for weatherObject in array
        {
            if weatherObject.city == city
            {
                return index
            }
            index += 1
        }
        return nil
    }
    
}
