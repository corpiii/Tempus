//
//  TimerModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/28.
//

import Foundation

struct TimerModel {
    let id: UUID
    var title: String
    var wasteTime: Double
    var toEntity: TimerEntity {
        let entity = TimerEntity()
        entity.uuid = id
        entity.title = title
        entity.wasteTime = wasteTime
        
        return entity
    }
}
