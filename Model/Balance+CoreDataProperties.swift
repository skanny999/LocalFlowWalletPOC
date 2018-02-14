//
//  Balance+CoreDataProperties.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension Balance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Balance> {
        return NSFetchRequest<Balance>(entityName: "Balance")
    }

    @NSManaged public var eur: String?
    @NSManaged public var ewa: String?
    @NSManaged public var userId: String?
    @NSManaged public var iota: String?
    @NSManaged public var user: User?

}
