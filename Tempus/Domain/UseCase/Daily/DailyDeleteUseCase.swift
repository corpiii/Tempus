//
//  DailyDeleteUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/02.
//

import Foundation

class DailyDeleteUseCase {
    let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func execute(model: DailyModel, _ completion: @escaping () -> Void) throws {
        try repository.delete(model)
        completion()
    }
}
