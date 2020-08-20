//
//  Firebase.swift
//  messageApp
//
//  Created by esra.yildiz on 23.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit
import MapKit

class FirebaseOperations
{
    class func getCurrentUser() -> User
    {
        return Auth.auth().currentUser!
    }
    
    class func saveUser() -> Void
    {
        let currentUser = getCurrentUser()
        let userInfo = ["email" : currentUser.email!, "id": currentUser.uid]
        Database.database().reference().child("Users").childByAutoId().setValue(userInfo)
    }
    
    class func getCurrentUserEmail() -> String
    {
        return getCurrentUser().email!
    }
    
    class func getCurrentUserUid() -> String
    {
        return getCurrentUser().uid
    }
    
    class func fetchFromContactList(completion: @escaping (Person) -> ())
    {
        Database.database().reference().child("ContactList").child(getCurrentUserUid()).observe(DataEventType.childAdded) { (snapshot) in
            let values = snapshot.value as! Dictionary<String,Any>
            let newPerson = Person.getPerson(dictionary: values)
            print(newPerson.image)
            completion(newPerson)
        }
    }
    
    class func fetchNotifications(completion: @escaping ([Dictionary<String,String>]) -> ())
    {
        let currentUserID = getCurrentUserUid()
        Database.database().reference().child("Notifications").child(currentUserID).observe(.childAdded, with: { (snapshot) in
            let children = snapshot.children.allObjects as! [DataSnapshot]
            var dictionary = [Dictionary<String,String>]()
            for child in children
            {
                dictionary.append(child.value as! Dictionary<String,String>)
            }
            completion(dictionary)
        })
        
    }
    
    class func saveToMedia(image: UIImage, email: String, name: String, surname: String ) -> Void
    {
        let uid = NSUUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("media")
        if let data = UIImageJPEGRepresentation(image, 0.5)
        {
            let mediaImagesRef = mediaFolder.child("\(uid).jpg")
            mediaImagesRef.putData(data, metadata: nil) { (metadata, error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
                else
                {
                    mediaImagesRef.downloadURL(completion: { (url, error) in
                        if let error = error
                        {
                            print(error.localizedDescription)
                        }
                        else
                        {
                            let post = ["image": url?.absoluteString as Any, "email": email, "uuid": uid, "name": name, "surname": surname] as [String : Any]
                            saveToContactList(post: post)
                        }
                    })
                }
            }
        }
        else
        {
            print("Image is not available")
        }
    }
    
    class func saveToChatMedia(image: UIImage, email: String, completion: @escaping ([String: String]?) -> ()) -> Void
    {
        let uid = NSUUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("media")
        if let data = UIImageJPEGRepresentation(image, 0.5)
        {
            let mediaImagesRef = mediaFolder.child("\(uid).jpg")
            mediaImagesRef.putData(data, metadata: nil) { (metadata, error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
                else
                {
                    mediaImagesRef.downloadURL(completion: { (url, error) in
                        if let error = error
                        {
                            print(error.localizedDescription)
                        }
                        else
                        {
                            let post = ["image": url?.absoluteString as Any, "email": email]
                            completion((post as! [String : String]))
                        } 
                    })
                }
            }
        }
        else
        {
            print("Image is not available")
        }
    }
    
    class func saveToContactList(post: [String : Any]) -> Void
    {
        Database.database().reference().child("ContactList").child(getCurrentUserUid()).childByAutoId().setValue(post)
    }
    
    class func removeNotifications(friendEmail: String) -> Void
    {
        findIDFromUser(email: friendEmail) { (friendId) in
            let currentUserID = getCurrentUserUid()
            Database.database().reference().child("Notifications").child(currentUserID).child(friendId).removeValue()
        }
        
    }
    
    class func signOut() -> Void
    {
        try! Auth.auth().signOut()
    }
    
    class func takeMessages(message: String,completion: @escaping (String,String) -> ()) -> Void
    {
        Database.database().reference().child(message).child(getCurrentUserUid()).observe(.childAdded) { (snapshot) in
            let valueDictionary = snapshot.value as! Dictionary<String,String>
            let message = valueDictionary["message"]
            let user = valueDictionary["email"]
            completion(message!, user!)
        }
    }
    
    class func findIDFromUser(email: String, completion: @escaping (String) -> ()) -> Void
    {
        Database.database().reference().child("Users").observe(.childAdded) { (snapshot) in
            let values = snapshot.value as! NSDictionary
            let user = values.allValues
            if user[0] as! String == email
            {
                let userID = user[1] as! String
                completion(userID)
            }
        }
    }
    
    class func saveToMessages(email: String, message: String) -> Void
    {
        let takenMessage = ["takenFrom" : getCurrentUserUid(), "message": message, "email": getCurrentUserEmail()]
        findIDFromUser(email: email) { (userID) in
            Database.database().reference().child("TakenMessages").child(userID).childByAutoId().setValue(takenMessage)
            Database.database().reference().child("Notifications").child(userID).child(getCurrentUserUid()).childByAutoId().setValue(takenMessage)
            let sendingMessage = ["to":  userID, "message" : message, "email": email]
        Database.database().reference().child("SendingMessages").child(getCurrentUserUid()).childByAutoId().setValue(sendingMessage)
        }
    }
    
    class func saveChatMessages(friendEmail: String, message: String, image: UIImage?, voiceURL: String?, userLocation: CLLocation?) -> Void
    {
        let dataReference = Database.database().reference()
        let email = getCurrentUserEmail()
        findIDFromUser(email: friendEmail) { (friendID) in
            if userLocation == nil
            {
                if image == nil
                {
                    if voiceURL == nil || voiceURL == ""
                    {
                        
                        dataReference.child("ChatMessages").child(getCurrentUserUid()).child(friendID).childByAutoId().setValue(["message": message, "email": email, "image": nil, "voiceURL": nil])
                        dataReference.child("ChatMessages").child(friendID).child(getCurrentUserUid()).childByAutoId().setValue(["message": message, "email": email, "image": nil, "voiceURL": nil])
                       
                       let takenMessage = ["takenFrom" : getCurrentUserUid(), "message": message, "email": getCurrentUserEmail()]
                        Database.database().reference().child("Notifications").child(friendID).child(getCurrentUserUid()).childByAutoId().setValue(takenMessage)
                        
                        
                    }
                    else
                    {
                        saveVoice(url: URL(string: voiceURL!)!, completion: { (post) in
                            dataReference.child("ChatMessages").child(getCurrentUserUid()).child(friendID).childByAutoId().setValue(post)
                            dataReference.child("ChatMessages").child(friendID).child(getCurrentUserUid()).childByAutoId().setValue(post)
                            let takenMessage = ["takenFrom" : getCurrentUserUid(), "message": "You take a voice record message.", "email": getCurrentUserEmail()]
                            Database.database().reference().child("Notifications").child(friendID).child(getCurrentUserUid()).childByAutoId().setValue(takenMessage)
                        })
                    }
                    
                }
                else
                {
                    saveToChatMedia(image: image!, email: email, completion: { (post) in
                        dataReference.child("ChatMessages").child(getCurrentUserUid()).child(friendID).childByAutoId().setValue(post)
                        dataReference.child("ChatMessages").child(friendID).child(getCurrentUserUid()).childByAutoId().setValue(post)
                        let takenMessage = ["takenFrom" : getCurrentUserUid(), "message": "You take an image message.", "email": getCurrentUserEmail()]
                        Database.database().reference().child("Notifications").child(friendID).child(getCurrentUserUid()).childByAutoId().setValue(takenMessage)
                    })
                }
            }
            else
            {
                let coordinates = userLocation?.coordinate
                let latitude = coordinates?.latitude
                let longitude = coordinates?.longitude
                dataReference.child("ChatMessages").child(getCurrentUserUid()).child(friendID).childByAutoId().setValue(["latitude": latitude as Any, "longitude": longitude as Any, "email":email])
                dataReference.child("ChatMessages").child(friendID).child(getCurrentUserUid()).childByAutoId().setValue(["latitude": latitude as Any, "longitude": longitude as Any, "email":email])
                let takenMessage = ["takenFrom" : getCurrentUserUid(), "message": "You take a location message.", "email": getCurrentUserEmail()]
                Database.database().reference().child("Notifications").child(friendID).child(getCurrentUserUid()).childByAutoId().setValue(takenMessage)
            }
            
        }
    }
    
    class func fetchChatMessages(friendEmail: String, completion: @escaping (Dictionary<String,Any>) -> ()) -> Void
    {
        findIDFromUser(email: friendEmail) { (friendID) in
            
            Database.database().reference().child("ChatMessages").child(getCurrentUserUid()).child(friendID).observe(.childAdded) { (snapshot) in
                let messageAndEmail = snapshot.value as! Dictionary<String,Any>
                completion(messageAndEmail)
            }
        }
    }
    
    class func register(email: String, password: String, completion: @escaping (String) -> ()) -> Void
    {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            var stringError = ""
            if let error = error
            {
                stringError = error.localizedDescription
                completion(stringError)
            }
            else
            {
                FirebaseOperations.saveUser()
                UserDefaultOperations.saveUser(email: email)
                completion(stringError)
            }
        }
    }
    
    class func signIn(email: String, password: String, completion: @escaping (String) -> () ) -> Void
    {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            var stringError = ""
            if let error = error
            {
                stringError = error.localizedDescription
                completion(stringError)
            }
            else
            {
                UserDefaultOperations.saveUser(email: email)
                completion(stringError)
            }
        }
    }
    
    class func saveVoice(url: URL, completion: @escaping ([String: String]?) -> ()) -> Void
    {
        let uid = NSUUID().uuidString
        let path = Storage.storage().reference().child("audios")
        let pathRef = path.child("\(uid).m4a")
        pathRef.putFile(from: url, metadata: nil) { (metadata, error) in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else
            {
                pathRef.downloadURL(completion: { (url, error) in
                    if let error = error
                    {
                        print(error.localizedDescription)
                    }
                    else
                    {
                        let stringURL = url?.absoluteString
                        let dictionary = ["voiceUrl": stringURL, "email": getCurrentUserEmail()]
                        completion((dictionary as! [String : String]))
                    }
                })
            }
        }
    }
}
