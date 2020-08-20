//
//  DetailedViewController.swift
//  weatherForecastAPI
//
//  Created by esra.yildiz on 17.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dayTemperature: UILabel!
    @IBOutlet weak var morningTemperature: UILabel!
    @IBOutlet weak var eveningTemperature: UILabel!
    @IBOutlet weak var nightTemperature: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    var stringURL: String = ""
    var weatherCodableArray:WeatherCodable.Json!
    var index = 0
    var historyTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
    }
    func setLabels()
    {
        cityName.text = (weatherCodableArray.city.name).uppercased()
        var weatherCodableList = weatherCodableArray.list
        explanationLabel.text = weatherCodableList[index].weather[0].description
        historyLabel.text = historyTitle
        dayTemperature.text = String(weatherCodableList[index].temp.day) + " °C"
        morningTemperature.text = String(weatherCodableList[index].temp.morn) + " °C"
        eveningTemperature.text = String(weatherCodableList[index].temp.eve) + " °C"
        nightTemperature.text = String(weatherCodableList[index].temp.night) + " °C"
        pressureLabel.text = String(weatherCodableList[index].pressure)
        humidityLabel.text = String(weatherCodableList[index].humidity) + "%"
        weatherImage.image = UIImage(named: weatherCodableList[index].weather[0].icon+".png")
    }
    
    

}
