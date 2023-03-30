//
//  TimerEntity+CoreDataProperties.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/29.
//
//

import Foundation
import CoreData


extension TimerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimerEntity> {
        return NSFetchRequest<TimerEntity>(entityName: "TimerEntity")
    }

    @NSManaged public var wasteTime: Double
    @NSManaged public var uuid: UUID?
    @NSManaged public var createdAt: Double

}

extension TimerEntity : Identifiable {

}
