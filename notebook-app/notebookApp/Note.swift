//
//  Note.swift
//  notebookApp
//
//  Created by esra.yildiz on 7.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation
import UIKit

class NewNote
{
    var text = ""
    var id = ""
    var image:[UIImage]?
    
    init(text: String,id: String, image: [UIImage]?) {
        self.text = text
        self.id = id
        self.image = image
    }
}
