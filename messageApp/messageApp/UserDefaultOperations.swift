//
//  UserDefaultOperations.swift
//  messageApp
//
//  Created by esra.yildiz on 25.07.2018.
//  Copyright © 2018 esra.yildiz. All rights reserved.
//

import Foundation

class UserDefaultOperations
{
    
    class func saveUser(email: String) -> Void
    {
        UserDefaults.standard.set(email, forKey: "user")
        UserDefaults.standard.synchronize()
    }
    
    class func removeUser() -> Void
    {
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
    }
    
    
    
    
}
