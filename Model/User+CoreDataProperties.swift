//
//  User+CoreDataProperties.swift
//  LocalFlowWallet
//
//  Created by Riccardo Scanavacca on 27/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var nickname: String?
    @NSManaged public var password: String?
    @NSManaged public var balance: Balance?
    @NSManaged public var transactions: NSSet?

}

// MARK: Generated accessors for transactions
extension User {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}
