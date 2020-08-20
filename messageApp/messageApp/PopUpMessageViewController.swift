//
//  PopUpMessageViewController.swift
//  messageApp
//
//  Created by esra.yildiz on 20.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PopUpMessageViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    var email = ""
    var name = ""
    @IBOutlet weak var messageText: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        messageText.text = "Enter a text"
        messageText.textColor = UIColor.lightGray
        messageText.delegate = self
        nameLabel.text = name
        if name == ""
        {
            nameLabel.text = email
        }
    }
    
    func exitPopUp()
    {
        self.view.removeFromSuperview()
    }
    
    //MARK: actions
    
    @IBAction func sendButtonClicked(_ sender: Any)
    {
        //var uid = ""
        let message: String = messageText.text
        FirebaseOperations.saveToMessages(email: self.email ,message: message)
        exitPopUp()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any)
    {
        exitPopUp()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.textColor == UIColor.lightGray
        {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty
        {
            textView.text = "Enter a text"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
