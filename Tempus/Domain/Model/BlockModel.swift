//
//  BlockModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/28.
//

import Foundation

struct BlockModel: Model, Hashable, Codable {
    let id: UUID
    var title: String
    var blockTime: Int
}
