//
//  DailyEntity+CoreDataProperties.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/29.
//
//

import Foundation
import CoreData


extension DailyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyEntity> {
        return NSFetchRequest<DailyEntity>(entityName: "DailyEntity")
    }

    @NSManaged public var title: String
    @NSManaged public var uuid: UUID
    @NSManaged public var startTime: Double
    @NSManaged public var repeatCount: Int
    @NSManaged public var focusTime: Double
    @NSManaged public var breakTime: Double
    @NSManaged public var createdAt: Double

}

extension DailyEntity : Identifiable {

}
