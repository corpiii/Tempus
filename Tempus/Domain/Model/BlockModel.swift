//
//  BlockModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/28.
//

import Foundation

struct BlockModel {
    let id: UUID
    var title: String
    var divideCount: Double
    var toEntity: BlockEntity {
        let entity = BlockEntity()
        entity.uuid = id
        entity.title = title
        entity.divideCount = Int16(divideCount)
        
        return entity
    }
}
