//
//  BlockModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/28.
//

import Foundation

struct BlockModel: Mode, Hashable {
    let id: UUID
    var title: String
    var divideCount: Int
}
