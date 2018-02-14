//
//  UpdateManager.swift
//  TokenFolio
//
//  Created by Riccardo Scanavacca on 24/06/2017.
//  Copyright © 2017 Riccardo Scanavacca. All rights reserved.
//

import UIKit
import CoreData

class UpdateManager {
    
    static func update(user: String, completion:@escaping((Bool, String?) -> Void)) {
        
        NetworkProvider.fetchJSON(forUser: user) { (updated, message) in
            
            completion(updated, message)
        }
    }
    

    func processUserJSON(json: [String : Any], completion:@escaping ((Bool) -> Void)) {
        
        var user: User?
        
        CoreDataProvider.shared.backgroundManagedObjectContext.perform {
            
            let userDict = json["user"] as! [String : Any]
            
            user = User.newUser(from: userDict )
            
            
            if let balanceDict = userDict["balance"] {
                
                let balance = Balance.newBalance(from: balanceDict as! [String : Any])
                
                print("Balance:\(balance.debugDescription)")
                
                user!.balance = balance
                
            }
            
            if let tranOut = userDict["txes_out"] {
                
                if let transactions = tranOut as? Array<Any> {
                    
                    for transaction in transactions {
 
                            let transaction = Transaction.newOutTransaction(from: transaction as! [String : Any])

                            self.process(transaction, for: user!)
                    }
                }
                
                if let tranIn = userDict["txes_in"] {

                    if let transactions = tranIn as? Array<Any> {
                        
                        for transaction in transactions {

                                let transaction = Transaction.newInTransaction(from: transaction as! [String : Any])
                            
                                self.process(transaction, for: user!)
                        }
                    }
                }
            }

            CoreDataProvider.shared.save()
            
            completion(true)
            
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: NSNotification.Name(rawValue:"LoginResult"), object: nil, userInfo: nil)
            
            print("User: \(user.debugDescription)")
        }
    }
    
    
    func process(_ transaction: Transaction, for user: User) {
        
        if let allTransactions = Transaction.allTransactions() {
            
            allTransactions.contains(transaction) ?
            user.addToTransactions(transaction) : CoreDataProvider.shared.managedObjectContext.delete(transaction)
            
        } else {
            
            user.addToTransactions(transaction)
        }
  
    }
    
    
    func processTxOut(from dict: [String : Any]) {
        
        CoreDataProvider.shared.backgroundManagedObjectContext.perform {
            
            let transaction = Transaction.newOutTransaction(from: dict)
            
            if let user = User.currentUsers()?.first {
                
                self.process(transaction, for: user)
            }
        }
        
        CoreDataProvider.shared.save()
    }
    
}

    
    





















