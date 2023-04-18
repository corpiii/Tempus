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
        let models = try repository.fetchAllDailyModel()
        
        completion(models)
    }
}
