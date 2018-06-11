//
//  UpdateProcessor.swift
//  LocalFlowWallet
//
//  Created by Riccardo on 11/06/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation

class UpdateProcessor {
    
    static func processUserJSON(json: [String : Any], completion:@escaping ((Bool) -> Void)) {
        
        let userDict = json["user"] as! [String : Any]
        
        if let user = User.currentUser() {
            
            addAllTransactions(fromDict: userDict, to: user)
            
        } else {
            
            processNewUser(withJSON: userDict)
        }
        
        CoreDataProvider.shared.save()
        
        completion(true)
    }
    
    static func processNewUser(withJSON json: [String : Any]) {
        
        let user = User.newUser(from: json)
        
        addBalance(fromDict: json, to: user)
        addAllTransactions(fromDict: json, to: user)
    }
    
    fileprivate static func addAllTransactions(fromDict dict: [String : Any], to user: User) {
        
        guard let allTransactions = Transaction.allTransactions() else { return }
        
        addTransactions(outgoing: true, to:allTransactions, from: dict, for: user)
        addTransactions(outgoing: false, to:allTransactions, from: dict, for: user)
    }
    
    
    fileprivate static func addTransactions(outgoing: Bool,to allTransactions:[Transaction], from dict: [String : Any], for user: User) {
        
        let transactionIds = allTransactions.map({ $0.id! })
        let txKey = outgoing ? "txes_in" : "txes_out"
        
        if let transactions = dict[txKey] as? [[String : Any]] {
            
            for transDict in transactions {
                
                if let id = transDict["id"] as? String {
                    
                    if !transactionIds.contains(id) {
                        
                        user.addToTransactions(Transaction.newTransaction(from: transDict, outgoing: outgoing))
                        
                    } else {
                        
                        updateStatus(of: allTransactions, withId: id, transDict)
                    }
                }
            }
        }
    }
    

    
    
    static func processNewSentTransaction(from dict: [String : Any]) {
        
        CoreDataProvider.shared.managedObjectContext.perform {
            
            User.currentUser()?.addToTransactions(Transaction.newTransaction(from: dict, outgoing: true))
        }
        
        CoreDataProvider.shared.save()
    }
    
    
    
    
    fileprivate static func addBalance(fromDict json: [String : Any], to user: User) {
        
        if let balanceDict = json["balance"] {
            
            let balance = Balance.newBalance(from: balanceDict as! [String : Any])
            user.balance = balance
        }
    }
    
    static func updateStatus(of allTransactions:[Transaction], withId id:String, _ transDict:[String : Any]) {
        
        let transactions = allTransactions.filter{ $0.id! == id }
        
        if let transaction = transactions.first {
            
            transaction.confirmed = transDict["status"] as! String == "confirmed" ? true : false
            
            if transaction.currency! == "iota" {
                
                if let tdId = transDict["iota_tx_id"] as? String, let txLink = transDict["iota_tx_href"] as? String {
                    
                    transaction.iotaId = tdId
                    transaction.iotaTxHref = txLink
                }
            }
        }
    }
    
    
    static func updateUserPassword(with password:String) {
        
        User.currentUser()?.password = password
        CoreDataProvider.shared.save()
    }
    
}
