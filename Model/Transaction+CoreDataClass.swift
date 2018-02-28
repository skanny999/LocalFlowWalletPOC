//
//  Transaction+CoreDataClass.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    
    struct keys {
        
        let id = "id"
        let fromNick = "from_nickname"
        let toNick = "to_nickname"
        let amount = "amount"
        let currency = "currency"
        let status = "status"
        let created = "created_at"
        let updated = "updated_at"
    }
    
    static func allTransactions() -> [Transaction]? {
        
        let transactiosFetch = CoreDataProvider.shared.transactionFetchRequest()
        
        do {
            let fetchedTransactions = try CoreDataProvider.shared.managedObjectContext.fetch(transactiosFetch) as [Transaction]
            
            return fetchedTransactions
            
        } catch {
            fatalError("Failed to fetch user: \(error)")
        }
        
    }
    
    static func newOutTransaction(from dict: [String : Any]) -> Transaction {

        return transaction(from: dict, outgoing: true)
    }
    
    
    static func newInTransaction(from dict: [String : Any]) -> Transaction {
        
        return transaction(from: dict, outgoing: false)
    }
    
    
    static func transaction(from dict: [String : Any], outgoing: Bool) -> Transaction {
        
        let transaction = CoreDataProvider.shared.newTransaction()
        let key = keys()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime,
                                   .withColonSeparatorInTimeZone,
                                   .withFullTime,
                                   .withFractionalSeconds]
        
        transaction.id = dict[key.id] as? String
        transaction.fromNickname = dict[key.fromNick] as? String
        transaction.toNickname = dict[key.toNick] as? String
        transaction.amount = dict[key.amount] as? String
        transaction.currency = dict[key.currency] as? String
        transaction.outgoing = outgoing
        
        if let createdString = dict[key.created] as? String {

            if let date = formatter.date(from: createdString) as NSDate? {
            
            transaction.createdAt = date
            }
        }
        
        if let updatedString = dict[key.updated] as? String, let date = formatter.date(from: updatedString) as NSDate? {
            
            transaction.updatedAt = date
        }
        
        if let confirmedString = dict[key.status] as? String {
            
            transaction.confirmed = confirmedString == "confirmed" ? true : false
            
        }

        return transaction
    }
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {

        return lhs.id == rhs.id
    }

}



