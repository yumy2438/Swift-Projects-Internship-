//
//  ViewControllerNewData.swift
//  weatherForecastAPI
//
//  Created by esra.yildiz on 12.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class ViewControllerNewData: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource
{    
    @IBOutlet weak var pickerViewCity: UIPickerView!
    @IBOutlet weak var pickerViewDay: UIPickerView!
    
    var cityIndex = 0
    var dayIndex = 0
    
    typealias BlockNewCityEntered = (() -> Void)
    var blockNewCityEntered: BlockNewCityEntered?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // MARK: Segue Delegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "IdResult"
        {
            let destinationVC = segue.destination as! ViewControllerResults
            destinationVC.weatherCity = Constants().turkeyCityList[cityIndex]
            destinationVC.weatherDay = Constants().dayList[dayIndex]
        }
    }
    
    // MARK: Action Functions
    
    @IBAction func getResultsTapped(_ sender: Any)
    {
        let object = WeatherObject(city: Constants().turkeyCityList[cityIndex], day: Constants().dayList[dayIndex])
        UserDefaultsClass.insertObject(weatherObject: object)
        performSegue(withIdentifier: "IdResult", sender: nil)
        self.blockNewCityEntered?()
    }
}

// MARK: PickerView Functions

extension ViewControllerNewData
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == pickerViewCity
        {
            return Constants().turkeyCityList[row]
        }
        else
        {
            return Constants().dayList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == pickerViewCity{
            return Constants().turkeyCityList.count
        }
        else
        {
            return Constants().dayList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerViewCity
        {
            cityIndex = row
        }
        if pickerView == pickerViewDay
        {
            dayIndex = row
        }
    }
}
