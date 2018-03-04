//
//  Balance+CoreDataProperties.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 04/03/2018.
//  Copyright © 2018 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension Balance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Balance> {
        return NSFetchRequest<Balance>(entityName: "Balance")
    }

    @NSManaged public var eur: Double
    @NSManaged public var ewa: Double
    @NSManaged public var iota: Int64
    @NSManaged public var userId: String?
    @NSManaged public var user: User?

}
