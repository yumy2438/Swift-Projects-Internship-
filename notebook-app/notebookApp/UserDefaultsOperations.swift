//
//  UserDefaultsOperations.swift
//  notebookApp
//
//  Created by esra.yildiz on 6.08.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation

class UserDefaultsOperations
{
    
    class func setFixedTopic()
    {
        let fixedTopics = ["Shopping", "Work", "Home", "Relationship"]
        UserDefaults.standard.set(fixedTopics, forKey: "savedArray")
        UserDefaults.standard.synchronize()
    }
    
    class func addNewTopic(newTopic: String)
    {
        var topicArray = UserDefaults.standard.stringArray(forKey: "savedArray")
        topicArray?.append(newTopic)
        setArray(array: topicArray!)
    }
    
    class func setArray(array: [String])
    {
        UserDefaults.standard.set(array, forKey: "savedArray")
        UserDefaults.standard.synchronize()
    }
    
    class func getArray() -> [String]
    {
        return (UserDefaults.standard.stringArray(forKey: "savedArray"))!
    }
    
    class func deleteTopic(topic: String)
    {
        var array = getArray()
        var index = 0
        for elem in array
        {
            if elem == topic
            {
                array.remove(at: index)
            }
            index += 1
        }
        setArray(array: array)
    }
    
}
