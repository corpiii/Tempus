//
//  DataManagerRepository.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/29.
//

import Foundation

protocol DataManagerRepository {
    func create(model: TimerModel) throws
    func create(model: BlockModel) throws
    func create(model: DailyModel) throws
    
    func fetch() throws -> [TimerEntity]
    func fetch() throws -> [BlockEntity]
    func fetch() throws -> [DailyEntity]
    
    func update(_ model: TimerModel) throws
    func update(_ model: BlockModel) throws
    func update(_ model: DailyModel) throws
    
    func delete(_ model: TimerModel) throws
    func delete(_ model: BlockModel) throws
    func delete(_ model: DailyModel) throws
}
