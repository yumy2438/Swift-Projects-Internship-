//
//  ViewController.swift
//  weatherForecastAPI
//
//  Created by esra.yildiz on 12.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class ViewControllerCityList: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCity: String!
    var selectedDay: String!
    var weatherArray = [WeatherObject]()
    
    override func viewDidLoad()
    {
        if UserDefaultsClass.isEmpty()
        {
            performSegue(withIdentifier: "IdNewData", sender: nil)
        }
        else
        {
            prepareArrays()
        }
        super.viewDidLoad()
        reloadPage()
    }
    
    func prepareArrays()
    {
        weatherArray.removeAll(keepingCapacity: false)
        weatherArray = UserDefaultsClass.getArray()
    }
    
    @objc func reloadPage()
    {
        self.prepareArrays()
        tableView.reloadData()
    }
    
    //MARK: Segue Delegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "IdSavedData"
        {
              let destinationVC = segue.destination as! ViewControllerResults
              destinationVC.weatherCity = selectedCity
              destinationVC.weatherDay = selectedDay
        }
        if segue.identifier == "IdNewData"
        {
              let destinationVC = segue.destination as! ViewControllerNewData
              destinationVC.blockNewCityEntered = {
                  self.reloadPage()
              }
        }
    }
    
    //MARK: Action Functions
    
    @IBAction func addButtonClicked(_ sender: Any)
    {
        performSegue(withIdentifier: "IdNewData", sender: nil)
    }
    
    //MARK: tableView Functions
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
   {
        if editingStyle == .delete
        {
            UserDefaultsClass.removeAt(index: indexPath.section)
            weatherArray.remove(at: indexPath.section)
            tableView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet, with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedCity = weatherArray[indexPath.section].city
        selectedDay = weatherArray[indexPath.section].day
        performSegue(withIdentifier: "IdSavedData", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return weatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityNameCell
        cell.cityName.text = weatherArray[indexPath.section].city
        return cell
    }
    
}

