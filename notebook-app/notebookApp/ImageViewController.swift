//
//  ImageViewController.swift
//  notebookApp
//
//  Created by esra.yildiz on 8.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image: UIImage?
    @IBOutlet weak var noteImage: UIImageView!
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        noteImage.image = image
        super.viewDidLoad()
    }
    @IBAction func closeButtonClicked(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
}
