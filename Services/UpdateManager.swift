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
    
    static func update(user: String, withPassword password: String, completion:@escaping((Bool, String?) -> Void)) {
        
        NetworkProvider.fetchTransactions(forUser: user, withPassword: password) { (updated, message) in
            
            completion(updated, message)
        }
    }
    
    
    static func updateNewTransactions(completion:@escaping (Bool) -> Void) {

        if let user = User.currentUser() {
            
            let transactionsCount = Transaction.allTransactions()?.count
            
            update(user: user.nickname!, withPassword: user.password!, completion: { (updated, message) in
                
                if updated {
                    
                    if transactionsCount != Transaction.allTransactions()?.count {
                        
                        completion(true)
                    }
                }
            })
        }
    }

    
    fileprivate func addIncomingTransactions(fromDict dict: [String : Any], to user: User) {
        
        if let allTransactions = Transaction.allTransactions() {
        
            let transactionIds = allTransactions.map({ $0.id! })
            
            if let transIn = dict["txes_in"] as? [[String : Any]] {

                for transDict in transIn {
                    
                    if let id = transDict["id"] as? String {
                        
                        if !transactionIds.contains(id) {
                            
                            user.addToTransactions(Transaction.newInTransaction(from: transDict))
                            
                        } else {
                            
                            updateStatus(of: allTransactions, withId: id, transDict)
                        }
                    }
                }
            }
            
            if let transIn = dict["txes_out"] as? [[String : Any]] {
                
                for transDict in transIn {
                    
                    if let id = transDict["id"] as? String {
                        
                        if !transactionIds.contains(id) {
                            
                            user.addToTransactions(Transaction.newInTransaction(from: transDict))
                            
                        } else {
                            
                            updateStatus(of: allTransactions, withId: id, transDict)
                        }
                    }
                }
            }
            
        } else {
            
            addTransactionsIn(fromDict: dict, to: user)
        }
    }
    

    func processUserJSON(json: [String : Any], completion:@escaping ((Bool) -> Void)) {
        
        let userDict = json["user"] as! [String : Any]
        
        if let user = User.currentUser() {
            
            addIncomingTransactions(fromDict: userDict, to: user)
            
        } else {
            
            processNewUser(withJSON: userDict)
            
        }
        
        CoreDataProvider.shared.save()
        
        completion(true)
    }



    func processNewUser(withJSON json: [String : Any]) {
        
        let user = User.newUser(from: json)
        
        addBalance(fromDict: json, to: user)
        
        addTransactionsOut(fromDict: json, to:user)
        
        addTransactionsIn(fromDict: json, to: user)
    }
    
    
    func processTxOut(from dict: [String : Any]) {
        
        CoreDataProvider.shared.managedObjectContext.perform {
            
            User.currentUser()?.addToTransactions(Transaction.newOutTransaction(from: dict))
        }
        
        CoreDataProvider.shared.save()
    }
    
    
    
    
    fileprivate func addTransactionsIn(fromDict json: [String : Any], to user: User) {
        
        if let tranIn = json["txes_in"] {
            
            if let transactions = tranIn as? Array<Any> {
                
                for transaction in transactions {
                    
                    user.addToTransactions(Transaction.newInTransaction(from: transaction as! [String : Any]))
                }
            }
        }
    }
    
    
    fileprivate func addTransactionsOut(fromDict json: [String : Any], to user: User) {
        
        if let tranOut = json["txes_out"] {
            
            if let transactions = tranOut as? Array<Any> {
                
                for transaction in transactions {
                    
                    user.addToTransactions(Transaction.newOutTransaction(from: transaction as! [String : Any]))
                }
            }
        }
    }
    
    
    fileprivate func addBalance(fromDict json: [String : Any], to user: User) {
        
        if let balanceDict = json["balance"] {
            
            let balance = Balance.newBalance(from: balanceDict as! [String : Any])
            user.balance = balance
        }
    }
    
    
    func updateStatus(of allTransactions:[Transaction], withId id:String, _ transDict:[String : Any]) {
        
        let transactions = allTransactions.filter{ $0.id! == id }
        
        if let transaction = transactions.first {
            
            print(transaction.id!)
            
            let isTransactionConfirmed = transDict["status"] as! String == "confirmed" ? true : false
            
            if transaction.confirmed != isTransactionConfirmed {
                
                transaction.confirmed = isTransactionConfirmed
                
                if transaction.currency! == "iota" {
                    
                    if let tdId = transDict["iota_tx_id"] as? String, let txLink = transDict["iota_tx_href"] as? String {
                        
                        transaction.iotaId = tdId
                        transaction.iotaTxHref = txLink
                    }
                }
            }
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

    
    





















