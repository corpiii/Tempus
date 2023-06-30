//
//  DailyModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/28.
//

import Foundation

struct DailyModel: Model, Hashable, Codable {
    let id: UUID
    var title: String
    var startTime: Double
    var repeatCount: Int
    var focusTime: Double
    var breakTime: Double
}
