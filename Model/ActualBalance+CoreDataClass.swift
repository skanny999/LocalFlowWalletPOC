//
//  ActualBalance+CoreDataClass.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 20/03/2018.
//  Copyright © 2018 Test. All rights reserved.
//
//

import Foundation
import CoreData


public class ActualBalance: NSManagedObject {
    
    struct keys {
        
        let id = "id"
        let userId = "user_id"
        let ewa = "ewa"
        let eur = "eur"
        let iota = "iota"
    }
    
    static func currentBalance() -> ActualBalance? {
        
        let actualBalanceFetch = NSFetchRequest<ActualBalance>(entityName: "ActualBalance")
        actualBalanceFetch.sortDescriptors = [NSSortDescriptor(key:"eur", ascending: true)]
        
        do {
            let fetchedActualBalance = try CoreDataProvider.shared.managedObjectContext.fetch(actualBalanceFetch) as [ActualBalance]
            
            return fetchedActualBalance.first
            
        } catch {
            
            fatalError("Failed to fetch user: \(error)")
        }
    }
    
    static func newActualBalance(from dict: [String : Any]) -> ActualBalance {
        
        let actualBalance = CoreDataProvider.shared.newActualBalance()
        let key = keys()
        
        actualBalance.userId = dict[key.userId] as? String
        
        actualBalance.ewa = dict[key.ewa] as? Double ?? 0.0
        actualBalance.eur = dict[key.eur] as? Double ?? 0.0
        actualBalance.iota = dict[key.iota] as? Int64 ?? 0
        
        return actualBalance
    }

}
