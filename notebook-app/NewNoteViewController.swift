//
//  NewNoteViewController.swift
//  notebookApp
//
//  Created by esra.yildiz on 6.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit
import CoreData

class NewNoteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var hiddenWriteNoteLabel: UILabel!
    @IBOutlet weak var writeNoteLabel: UILabel!
    
    @IBOutlet weak var topicPickerVire: UIPickerView!

    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var constraintLeadingNoteLabel: NSLayoutConstraint!
    @IBOutlet weak var constraintTopNoteLabel: NSLayoutConstraint!

    
    
    var topic = ""
    var topicArray = [String]()
    var pickerIndex = 0
    var imageArray = [UIImage]()
    var image: UIImage?
    var placeHolderText = "Enter a text"
    
    typealias Changed = () -> Void
    var newNoteEntered: Changed?
    var changedTopic: Changed?
    
    
    override func viewDidLoad()
    {
        hiddenWriteNoteLabel.isHidden = true
        super.viewDidLoad()
        topicArray = CoreData.getTopic()
        noteTextView.layer.masksToBounds = false
        noteTextView.layer.shadowColor = UIColor.black.cgColor
        noteTextView.layer.shadowOpacity = 5
        noteTextView.layer.shadowOffset = CGSize(width: -3, height: 3)
        noteTextView.layer.shadowRadius = 2
        pickerIndex = CoreData.getIndex(searchedTopic: topic)
        topicPickerVire.selectRow(pickerIndex, inComponent: 0, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    
//        self.writeNoteLabel.textColor = UIColor.black
//        UIView.animate(withDuration: 0.5) {
//            self.writeNoteLabel.frame = self.hiddenWriteNoteLabel.frame
//        }
        
        UIView.animate(
            withDuration: 1,
            animations: {
                self.constraintLeadingNoteLabel.constant = 16
                self.constraintTopNoteLabel.constant = 8
        }) { (isComplete) in
            self.writeNoteLabel.textColor = UIColor.black
            self.writeNoteLabel.font = UIFont.boldSystemFont(ofSize: 17)
            if self.writeNoteLabel.text?.last != ":"
            {
                self.writeNoteLabel.text?.append(":")
            }
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return topicArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return topicArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if topicArray.count > row
        {
            topic = topicArray[row]
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any)
    {
        if let text = noteTextView.text
        {
            CoreData.saveNote(topic: topic, text: text, imageArray: imageArray)
            self.newNoteEntered?()
        }
        else
        {
            esraCreateAnAlert(message: "You should write a note.")
        }
        noteTextView.text = ""
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func choosePhoto()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        imageArray.append(image!)
        imageCollectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let item = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        item.noteImage?.image = imageArray[indexPath.row]
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = imageArray[indexPath.row]
        openPopUpMessage(image: image)
    }
    
    func openPopUpMessage(image: UIImage)
    {
        let imagePopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imagePopUp") as! ImageViewController
        imagePopUpVC.image = image
        self.addChildViewController(imagePopUpVC)
        imagePopUpVC.view.frame = self.view.frame
        self.view.addSubview(imagePopUpVC.view)
        imagePopUpVC.didMove(toParentViewController: self)
    }
    
    @IBAction func addImageButtonClicked(_ sender: Any)
    {
        choosePhoto()
    }
    
}

extension UIViewController
{
    func esraCreateAnAlert( message: String) -> Void
    {
        let alert = UIAlertController(title: "UPS", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
