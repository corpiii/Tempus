//
//  DailyEntity+CoreDataProperties.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/27.
//
//

import Foundation
import CoreData


extension DailyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyEntity> {
        return NSFetchRequest<DailyEntity>(entityName: "DailyEntity")
    }

    @NSManaged public var divideCount: Int16

}

extension DailyEntity : Identifiable {

}
