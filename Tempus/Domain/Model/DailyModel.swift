//
//  DailyModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/28.
//

import Foundation

struct DailyModel {
    let id: UUID
    var title: String
    var startTime: Double
    var repeatCount: Int
    var focusTime: Double
    var breakTime: Double
    var toEntity: DailyEntity {
        let entity = DailyEntity()
        
        entity.uuid = id
        entity.title = title
        entity.startTime = startTime
        entity.repeatCount = repeatCount
        entity.focusTime = focusTime
        entity.breakTime = breakTime
        
        return entity
    }
}
