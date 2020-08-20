//
//  PopUpViewController.swift
//  notebookApp
//
//  Created by esra.yildiz on 7.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var noteText: UITextView!
    var note = ""
    var topic = ""
    var index = 0
    var stringId = ""
    var imageArray = [UIImage]()
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    
    typealias UpdatedNoteEntered = () -> Void
    var updatedNoteEntered: UpdatedNoteEntered?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        noteText.text = note
        closeButton.backgroundColor = UIColor.red
        closeButton.layer.cornerRadius = closeButton.frame.size.height/2
    }
    
    @IBAction func saveButtonClicked(_ sender: Any)
    {
        CoreData.updateData(topic:topic, id: stringId, updatedValue: noteText.text)
        self.updatedNoteEntered?()
        exitPopUp()
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any)
    {
        CoreData.removeData(topic:topic, id: stringId)
        self.updatedNoteEntered?()
        exitPopUp()
    }
    
    @IBAction func closeButtonClicked(_ sender: Any)
    {
        exitPopUp()
    }
    
    func exitPopUp()
    {
        self.view.removeFromSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell2", for: indexPath) as! ImageCollectionViewCell
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
    
}
