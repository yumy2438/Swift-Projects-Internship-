//
//  Extensions.swift
//  esleKazan
//
//  Created by esra.yildiz on 9.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func esraCreateAnAlert(title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "REPLAY", style: .default) { (completionAct) in
            let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let gameBoard = storyBoard.instantiateViewController(withIdentifier: "gameBoard")
            delegate.window?.rootViewController = gameBoard
        }
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true)
    }
}
