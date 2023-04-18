//
//  DailyFetchUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/18.
//

import Foundation

final class DailyFetchUseCase {
    let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func execute(_ completion: @escaping ([DailyModel]) -> Void) throws {
        let entities = try repository.fetchAllDailyEntity()
        let models = transform(entities: entities)
        
        completion(models)
    }
    
    private func transform(entities: [DailyEntity]) -> [DailyModel] {
        return entities.map { entity in
            DailyModel(id: entity.uuid,
                       title: entity.title,
                       startTime: entity.startTime,
                       repeatCount: entity.repeatCount,
                       focusTime: entity.focusTime,
                       breakTime: entity.breakTime)
        }
    }
}
