//
//  Constants.swift
//  messageApp
//
//  Created by esra.yildiz on 19.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import Foundation

class Constants
{
    class func createAnAlert(message: String, title:String, in vc: UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertButton = UIAlertAction(title: "ERROR", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(alertButton)
        vc.present(alert,animated: true)
    }
}
