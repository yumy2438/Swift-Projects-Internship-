//
//  ViewController.swift
//  notebookApp
//
//  Created by esra.yildiz on 6.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var noteCollectionView: UICollectionView!
    var topic = ""
    var topics = [String]()
    var textAndIdsArrays = [NewNote]()
    var width: Double = 177
    var height: Double = 100
    var index: Int!
    
    @IBOutlet weak var topicText: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UserDefaultsOperations.setFixedTopic()
        topics = CoreData.getTopic()
        topic = topics[0]
        prepareArray()
        noteCollectionView.sizeToFit()
    }
    
    func prepareArray()
    {
        textAndIdsArrays.removeAll(keepingCapacity: false)
        CoreData.fetchNotes(topic: topic) { (newNote) in
            self.textAndIdsArrays.append(newNote)
            self.noteCollectionView.reloadData()
        }
        if textAndIdsArrays.count == 0
        {
            let newNote = NewNote(text: "Click for new note", id: "0", image: nil)
            textAndIdsArrays.append(newNote)
            noteCollectionView.reloadData()
        }
        changeTitle()
    }
    
    @IBAction func chooseTopicButtonClicked(_ sender: Any)
    {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        for topic in topics
        {
            let action = createAction(actionTitle: topic)
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    func changeTitle()
    {
        topicText.text = topic.uppercased()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return textAndIdsArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let text = textAndIdsArrays[indexPath.row].text
        let height = text.height(withConstrainedWidth: 177, font: UIFont(descriptor: UIFontDescriptor(name: text, size: 17), size: 17))
        return CGSize(width: 177, height: height+20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = noteCollectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! NoteCollectionViewCell
        cell.noteLabel.text = textAndIdsArrays[indexPath.row].text
        return cell
    }
    
    func createAction(actionTitle: String) -> UIAlertAction
    {
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            self.topic = actionTitle
            self.prepareArray()
            self.noteCollectionView.reloadData()
        }
        return action
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if textAndIdsArrays[indexPath.row].id == "0"
        {
            performSegue(withIdentifier: "toNewNote", sender: nil)
        }
        else
        {
            let object = textAndIdsArrays[indexPath.row]
            index = indexPath.row
            performSegue(withIdentifier: "toShowNote", sender: nil)
            //openPopUpMessage(noteText: object.text, index: indexPath.row, id: object.id, noteImageArray: object.image)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewNote"
        {
            let destinationVC = segue.destination as! NewNoteViewController
            destinationVC.newNoteEntered = {
                self.prepareArray()
            }
            destinationVC.changedTopic = {
                self.topics = UserDefaultsOperations.getArray()
            }
            destinationVC.topic = topic
        }
        if segue.identifier == "toShowNote"
        {
            let destinationVC = segue.destination as! SavedNotesViewController
            let object = textAndIdsArrays[index]
            destinationVC.note = object.text
            destinationVC.topic = topic
            if object.image != nil
            {
                destinationVC.imageArray = object.image!
            }
            destinationVC.stringId = object.id
            destinationVC.updatedNoteEntered = {
                self.prepareArray()
            }
            
        }
    }
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil)
        
        return ceil(boundingBox.height)
}
}
