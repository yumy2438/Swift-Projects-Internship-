//
//  ViewControllerResults.swift
//  weatherForecastAPI
//
//  Created by esra.yildiz on 12.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import Alamofire

class ViewControllerResults: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var weatherCity: String!
    var weatherDay: String!
    var weatherCodableList:[WeatherCodable.List] = []
    var weatherCodableJson: WeatherCodable.Json!
    var stringURL: String!
    var index = 0
    var historyTitle: String!

    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad()
    {
        stringURL = WeatherAPI.forecastMethod(cityName: weatherCity, day: weatherDay)
        super.viewDidLoad()
        WeatherAPI.getForecast(url: URL(string: stringURL)!) { (results:WeatherCodable.Json) in
            self.weatherCodableList = results.list
            self.weatherCodableJson = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        cityLabel.text=weatherCity.uppercased()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedResults"
        {
            let destinationVC = segue.destination as! DetailedViewController
            destinationVC.weatherCodableArray = weatherCodableJson
            destinationVC.index = index
            destinationVC.historyTitle = historyTitle
        }
    }

    
    //MARK: TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        
        let weatherInfoItem = self.weatherCodableList[indexPath.section]
        cell.weatherTemperature.text = String(weatherInfoItem.temp.day) + " °C"

        if let weather = weatherInfoItem.weather.first
        {
            cell.weatherExplanation.text = String(weather.description)
            cell.weatherImage.image = UIImage(named: weather.icon)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return weatherCodableList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: date!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.section
        historyTitle = self.tableView(tableView, titleForHeaderInSection: index)
        performSegue(withIdentifier: "toDetailedResults", sender: nil)
    }
    
}
