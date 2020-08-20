//
//  LoginViewController.swift
//  messageApp
//
//  Created by esra.yildiz on 19.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any)
    {
        if emailText.text != "" && passwordText.text != ""
        {
            FirebaseOperations.signIn(email: emailText.text!, password: passwordText.text!) { (error) in
                if error != ""
                {
                    self.createAnAlert(message: error, title: "OK")
                }
                else
                {
                    self.goContactViewPage()
                }
            }
        }
        else
        {
            self.createAnAlert(message: "You cannot leave blank email and password", title: "OK")
        }
    }
    
    @IBAction func registerButtonClicked(_ sender: Any)
    {
        if emailText.text != "" && passwordText.text != ""
        {
            FirebaseOperations.register(email: emailText.text!, password: passwordText.text!) { (error) in
                if error != ""
                {
                    self.createAnAlert(message: error, title: "OK")
                }
                else
                {
                    self.goContactViewPage()
                }
            }
        }
        else
        {
            self.createAnAlert(message: "You cannot leave blank email and password", title: "OK")
        }
        
    }
    
    func goContactViewPage() -> Void
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.rememberLogin()
    }
    
}

