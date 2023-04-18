//
//  BlockEntity+CoreDataProperties.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/29.
//
//

import Foundation
import CoreData


extension BlockEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlockEntity> {
        return NSFetchRequest<BlockEntity>(entityName: "BlockEntity")
    }

    @NSManaged public var divideCount: Int
    @NSManaged public var createdAt: Double
    @NSManaged public var uuid: UUID
    @NSManaged public var title: String

    var toModel: BlockModel {
        return BlockModel(id: uuid,
                          title: title,
                          divideCount: divideCount)
    }
}

extension BlockEntity : Identifiable {

}
