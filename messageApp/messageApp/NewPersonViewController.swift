//
//  NewPersonViewController.swift
//  messageApp
//
//  Created by esra.yildiz on 19.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

//let uuid = NSUUID().uuidString



class NewPersonViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameText: UITextField!
    @IBOutlet weak var personSurnameText: UITextField!
    @IBOutlet weak var personEmailText: UITextField!
    
    var personEmail = ""
    
    typealias BlockNewCityEntered = (() -> Void)
    var blockNewCityEntered: BlockNewCityEntered?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if self.personEmail != ""
        {
            self.personEmailText.text = self.personEmail
        }
        enablePictureTapped()
        //self.view.backgroundColor = UserDefaults.standard.object(forKey: "renk") as? UIColor
    }
    
    @objc func choosePhoto()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        personImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonClicked(_ sender: Any)
    {
        if self.personEmailText.text != "" , self.personSurnameText.text != "" , self.personNameText.text != ""
        {
            FirebaseOperations.saveToMedia(image: personImageView.image!, email: self.personEmailText.text!, name:self.personNameText.text!, surname: self.personSurnameText.text!)
        }
        setPage()
        performSegue(withIdentifier: "toContact2", sender: nil)
    }
    
    func setPage() -> Void
    {
        self.personImageView.image = #imageLiteral(resourceName: "choosephoto.jpg")
        self.personSurnameText.text = ""
        self.personNameText.text = ""
        self.personEmailText.text = ""
    }
    
    func enablePictureTapped()
    {
        personImageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(NewPersonViewController.choosePhoto))
        personImageView.addGestureRecognizer(recognizer)
    }
    

}
