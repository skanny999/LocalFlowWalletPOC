//
//  Balance+CoreDataClass.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Balance)
public class Balance: NSManagedObject {
    
    struct keys {
        
        let id = "id"
        let userId = "user_id"
        let ewa = "ewa"
        let eur = "eur"
        let iota = "iota"
    }
    
    static func currentBalance() -> Balance? {
        
        let balanceFetch = NSFetchRequest<Balance>(entityName: "Balance")
        balanceFetch.sortDescriptors = [NSSortDescriptor(key:"eur", ascending: true)]
        
        do {
            let fetchedBalance = try CoreDataProvider.shared.managedObjectContext.fetch(balanceFetch) as [Balance]
            
            return fetchedBalance.first
            
        } catch {
            
            fatalError("Failed to fetch user: \(error)")
        }
    }
    
    static func newBalance(from dict: [String : Any]) -> Balance {
        
        let balance = CoreDataProvider.shared.newBalance()
        let key = keys()
        
        balance.userId = dict[key.userId] as? String
        
        balance.ewa = dict[key.ewa] as? Double ?? 0.0
        balance.eur = dict[key.eur] as? Double ?? 0.0
        balance.iota = dict[key.iota] as? Int64 ?? 0
        
        return balance
    }
    

}
