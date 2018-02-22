//
//  TFCoreDataProvider.swift
//  TokenFolio
//
//  Created by Riccardo Scanavacca on 09/07/2017.
//  Copyright © 2017 Riccardo Scanavacca. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoreDataProvider {
    
    var managedObjectContext : NSManagedObjectContext
    var backgroundManagedObjectContext : NSManagedObjectContext
    
    static let shared = CoreDataProvider()
        
    private init(){
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        backgroundManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundManagedObjectContext.parent = managedObjectContext
    }

    
    func newUser() -> User {
        
        return NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as! User

    }
    
    func newBalance() -> Balance {
        
        return NSEntityDescription.insertNewObject(forEntityName: "Balance", into: managedObjectContext) as! Balance
        
    }
    
    func newTransaction() -> Transaction {
        
        return NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: managedObjectContext) as! Transaction
        
    }
    
    func fetchUser(completion: @escaping (User?) -> ()) {
        
        managedObjectContext.perform {
            
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key:"nickname", ascending: true)]
            
            let results  = try! fetchRequest.execute()
            
            if results.count == 0 {
                
                completion (nil)
                
            } else if let user = results.first {
                
                completion(user)
            }

        }
    }
    

    
    func fetchAllTransactions(completion: @escaping ([Transaction]) -> ()) {
        
        managedObjectContext.perform {
            
            let fetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            let results = try! fetchRequest.execute()
            
            completion (results)
            
        }
    }
    
    
    func transactionsFetchResultController() -> NSFetchedResultsController<Transaction> {
        
        let fetchedResultController = NSFetchedResultsController<Transaction>(fetchRequest: transactionFetchRequest(),
                                                                              managedObjectContext: managedObjectContext,
                                                                              sectionNameKeyPath: nil,
                                                                              cacheName: nil)

        return fetchedResultController

    }
    
    
    func transactionFetchRequest() -> NSFetchRequest<Transaction> {

        let request = NSFetchRequest<Transaction>(entityName: "Transaction")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        return request

    }

    
    func save() {
        
        do {
            
            try backgroundManagedObjectContext.save()
            
            managedObjectContext.perform {
                
                do {
                    try self.managedObjectContext.save()
                    
                } catch {
                    
                    fatalError("Failure to save context: \(error)")
                }
            }
        } catch {
            
            fatalError("Failure to save context: \(error)")
        }
    }
  
}



    
    
    


