//
//  PassNavigationController.swift
//  messageApp
//
//  Created by esra.yildiz on 19.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class PassNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "toContactt", sender: nil)
    }


}
