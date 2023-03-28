//
//  DataManagerRepository.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/29.
//

import Foundation

protocol DataManagerRepository {
    func create(mode: TimerModel) throws
    func create(mode: BlockModel) throws
    func create(mode: DailyModel) throws
    
    func fetch() throws -> [TimerModel]
    func fetch() throws -> [BlockModel]
    func fetch() throws -> [DailyModel]
    
    func update(_ mode: TimerModel) throws
    func update(_ mode: BlockModel) throws
    func update(_ mode: DailyModel) throws
    
    func delete(_ model: TimerModel) throws
    func delete(_ model: BlockModel) throws
    func delete(_ model: DailyModel) throws
}
