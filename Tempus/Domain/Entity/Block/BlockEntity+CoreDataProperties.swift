//
//  BlockEntity+CoreDataProperties.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/27.
//
//

import Foundation
import CoreData


extension BlockEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlockEntity> {
        return NSFetchRequest<BlockEntity>(entityName: "BlockEntity")
    }

    @NSManaged public var uuid: UUID
    @NSManaged public var startTime: Double
    @NSManaged public var repeatCount: Int16
    @NSManaged public var focusTime: Double
    @NSManaged public var breakTime: Double

}

extension BlockEntity : Identifiable {

}
