//
//  User+CoreDataClass.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    struct keys {
        
        let id = "id"
        let email = "email"
        let nickname = "nickname"
        let createdAt = "created_at"
        let updateAt = "updated_at"
        
    }
    
    static func currentUser() -> User? {
        
        return currentUsers()?.first
    }
    
    static func currentUsers() -> [User]? {
        
        let userFetch = NSFetchRequest<User>(entityName: "User")
        userFetch.sortDescriptors = [NSSortDescriptor(key:"nickname", ascending: true)]
        
        do {
            let fetchedUsers = try CoreDataProvider.shared.managedObjectContext.fetch(userFetch) as [User]
            
            return fetchedUsers
            
        } catch {
            fatalError("Failed to fetch user: \(error)")
        }

    }
    
    static func newUser(from dict: [String : Any]) -> User {
        
        let user = CoreDataProvider.shared.newUser()
        let key = keys()
        
        user.id = dict[key.id] as? String
        user.email = dict[key.email] as? String
        user.nickname = dict[key.nickname] as? String
        
        return user
    }


}
