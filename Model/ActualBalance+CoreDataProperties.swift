//
//  ActualBalance+CoreDataProperties.swift
//  LocalFlowWallet
//
//  Created by Riccardo Scanavacca on 20/03/2018.
//  Copyright © 2018 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension ActualBalance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActualBalance> {
        return NSFetchRequest<ActualBalance>(entityName: "ActualBalance")
    }

    @NSManaged public var eur: Double
    @NSManaged public var ewa: Double
    @NSManaged public var iota: Int64
    @NSManaged public var userId: String?

}
