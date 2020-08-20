//
//  Archieve.swift
//  notebookApp
//
//  Created by esra.yildiz on 8.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation
import UIKit

class Archieve
{
    class func changeImagesToData(imageArray: [UIImage]) -> Any
    {
        var CDataArray = NSMutableArray()
        for image in imageArray
        {
            let data : NSData = NSData(data: UIImagePNGRepresentation(image)!)
            CDataArray.add(data)
        }
        let coreDataObject = NSKeyedArchiver.archivedData(withRootObject: CDataArray)
        return coreDataObject
    }
    
    class func changeToImage(imageData: Data) -> NSArray?
    {
        let mySavedData = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? NSArray
        return mySavedData
        
    }
    
}
