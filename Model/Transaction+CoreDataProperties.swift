//
//  Transaction+CoreDataProperties.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 03/03/2018.
//  Copyright © 2018 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: String?
    @NSManaged public var confirmed: Bool
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var currency: String?
    @NSManaged public var fromNickname: String?
    @NSManaged public var id: String?
    @NSManaged public var outgoing: Bool
    @NSManaged public var toNickname: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var iotaId: String?
    @NSManaged public var iotaHref: String?
    @NSManaged public var user: User?

}
