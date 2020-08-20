//
//  PersonClass.swift
//  messageApp
//
//  Created by esra.yildiz on 20.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//
import UIKit
import Foundation

public class Person
{
    var name: String = ""
    var surname: String = ""
    var email: String = ""
    var image: String = ""
    
    
    class func getPerson(dictionary: Dictionary<String,Any>) -> Person
    {
        let newPerson = Person()
        newPerson.name = dictionary["name"] as! String
        newPerson.surname = dictionary["surname"] as! String
        newPerson.image = dictionary["image"] as! String
        newPerson.email = dictionary["email"] as! String
        return newPerson
    }
    
    
}
