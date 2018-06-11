//
//  UpdateManager.swift
//  TokenFolio
//
//  Created by Riccardo Scanavacca on 24/06/2017.
//  Copyright © 2017 Riccardo Scanavacca. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class UpdateManager {
    
    static func updateNewTransactions(completion:@escaping (Bool) -> Void) {
        
        if let user = User.currentUser() {
            
            let transactionsCount = Transaction.allTransactions()?.count
            
            updateTransactions(for: user.nickname!, withPassword: user.password!) { (updated, message) in
                
                if updated {
                    
                    if transactionsCount != Transaction.allTransactions()?.count {
                        
                        completion(true)
                    }
                }
            }
        }
    }
    
    
    static func updateTransactions(for user: String, withPassword password: String, completion:@escaping((Bool, String?) -> Void)) {
        
        NetworkProvider.fetchTransactions(forUser: user, withPassword: password) { (updated, message) in
            
            if updated {
                
               UpdateProcessor.updateUserPassword(with:password)
            }
            completion(updated, message)
        }
    }
    

    
    static func logout() {
        
        if let users = User.currentUsers() {
            
            for user in users {
                
                if let balance = user.balance {
                    
                    CoreDataProvider.shared.managedObjectContext.delete(balance)
                }
                
                if let transactions = user.transactions {
                    
                    for transaction in transactions {
                        
                        CoreDataProvider.shared.managedObjectContext.delete(transaction as! Transaction)
                    }
                }
                CoreDataProvider.shared.managedObjectContext.delete(user)
            }
        }
        
        if let balance = Balance.currentBalance() {
            
            CoreDataProvider.shared.managedObjectContext.delete(balance)
        }
        
        if let transactions = Transaction.allTransactions(), transactions.count > 0 {
            
            for transaction in transactions {
                
                CoreDataProvider.shared.managedObjectContext.delete(transaction)
            }
        }
        
        CoreDataProvider.shared.save()
    }
    
}

    
    





















