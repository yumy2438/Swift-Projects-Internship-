//
//  CoreDataOperations.swift
//  notebookApp
//
//  Created by esra.yildiz on 6.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreData
{
    class func setTopic() -> Void
    {
        let fixedTopic = getTopic()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var index = 0
        for topic in fixedTopic
        {
            let newTopic = NSEntityDescription.insertNewObject(forEntityName: "Topic", into: context)
            newTopic.setValue(index, forKey: "id")
            newTopic.setValue(topic, forKey: "name")
            index += 1
        }
    }
    
    class func getTopic() -> [String]
    {
        return ["Shopping", "Work", "Home", "Friends", "Family"]
    }
    
    class func saveNote(topic: String, text: String, imageArray: [UIImage])
    {
        let coreDataObject = Archieve.changeImagesToData(imageArray: imageArray)
        let id = NSUUID().uuidString
        let topicId = getIndex(searchedTopic: topic)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
        newNote.setValue(id,forKey: "id")
        newNote.setValue(text, forKey: "text")
        newNote.setValue("\(topicId)", forKey: "topicId")
        newNote.setValue(coreDataObject, forKey: "imageArray")
        
        do
        {
            try context.save()
            print("saveNote operation is successful")
        }
        catch
        {
            print("saveNote operation is not successful!")
        }
    }
    
    class func fetchNotes(topic: String, completion: @escaping (NewNote)-> ()) -> Void
    {
        let topicId = getIndex(searchedTopic: topic)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        fetchRequest.predicate = NSPredicate(format: "topicId =  %@", "\(topicId)")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let notes = try context.fetch(fetchRequest)
            if notes.count > 0
            {
                for note in notes as! [NSManagedObject]
                {
                    
                    if let text = note.value(forKey: "text") as? String
                    {
                        if let id = note.value(forKey: "id") as? String
                        {
                            var imageArray = [UIImage]()
                            if let imageData = note.value(forKey: "imageArray") as? Data
                            {
                                let imageDataArray = Archieve.changeToImage(imageData: imageData)
                                for imageData in imageDataArray!
                                {
                                    let image = UIImage(data: imageData as! Data)
                                    imageArray.append(image!)
                                }
                            }
                            let newNote = NewNote(text: text, id: id, image: imageArray)
                            completion(newNote)
                        }
                    }
                }
            }
        }
        catch
        {
            print("We cannot fetch any notes.")
        }
    }
    
    class func updateData(topic:String, id: String, updatedValue: String, updatedImageArray: [UIImage]) -> Void
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        fetchRequest.predicate = NSPredicate(format: "id =  %@", id)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let notes = try context.fetch(fetchRequest)
            for note in notes as! [NSManagedObject]
            {
                if note.value(forKey: "id") as! String == id
                {
                    note.setValue(updatedValue, forKey: "text")
                    let data = Archieve.changeImagesToData(imageArray: updatedImageArray)
                    note.setValue(data, forKey: "imageArray")
                }
            }
        }
        catch
        {
            print("We cannot update.")
        }
        do
        {
            try context.save()
        }
        catch
        {
            print("noo")
        }
    }
    
    class func removeData(topic:String, id: String) -> Void
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        fetchRequest.predicate = NSPredicate(format: "id =  %@", id)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let notes = try context.fetch(fetchRequest)
            for note in notes as! [NSManagedObject]
            {
                if note.value(forKey: "id") as! String == id
                {
                    context.delete(note)
                }
            }
        }
        catch
        {
            print("We cannot update.")
        }
        do
        {
            try context.save()
        }
        catch
        {
            print("noo")
        }
    }
    
    class func removeTopicContent(topic: String) -> Void
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        fetchRequest.predicate = NSPredicate(format: "topic =  %@", topic)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let notes = try context.fetch(fetchRequest)
            if notes.count > 0
            {
                for note in notes as! [NSManagedObject]
                {
                    context.delete(note)
                }
            }
        }
        catch
        {
            print("We cannot update.")
        }
    }
    
    class func getIndex(searchedTopic: String) -> Int
    {
        let fixedTopic = getTopic()
        var index = 0
        for topic in fixedTopic
        {
            if topic == searchedTopic
            {
                return index
            }
            index += 1
        }
        return index
    }
    
}
