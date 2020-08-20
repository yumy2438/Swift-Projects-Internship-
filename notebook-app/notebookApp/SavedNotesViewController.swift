//
//  SavedNotesViewController.swift
//  notebookApp
//
//  Created by esra.yildiz on 14.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class SavedNotesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    typealias UpdatedNoteEntered = () -> Void
    var updatedNoteEntered: UpdatedNoteEntered?
    
    var note = ""
    var topic = ""
    var stringId = ""
    var imageArray = [UIImage]()
    var image: UIImage?

    override func viewDidLoad()
    {
        noteText.text = note
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonClicked(_ sender: Any)
    {
        CoreData.updateData(topic:topic, id: stringId, updatedValue: noteText.text, updatedImageArray: imageArray)
        self.updatedNoteEntered?()
        goToNotePage()
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any)
    {
        CoreData.removeData(topic:topic, id: stringId)
        self.updatedNoteEntered?()
        goToNotePage()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        let image: UIImage = (imageArray[indexPath.row])
        item.noteImage?.image = image
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
    
    func goToNotePage()
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImageButtonClicked(_ sender: Any)
    {
        choosePhoto()
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

}
