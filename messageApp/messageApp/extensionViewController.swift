//
//  extension.swift
//  messageApp
//
//  Created by esra.yildiz on 19.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController
{
    func createAnAlert(message: String, title:String)
    {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertButton = UIAlertAction(title: title, style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(alertButton)
        self.present(alert, animated: true)
    }
}
