//
//  Constant.swift
//  messageApp
//
//  Created by esra.yildiz on 6.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation
import UIKit


class Constant
{
    func getDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    
}
