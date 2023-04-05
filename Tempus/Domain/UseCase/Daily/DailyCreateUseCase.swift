//
//  DailyCreateUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/01.
//

import Foundation

final class DailyCreateUseCase {
    let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func execute(model: DailyModel, _ completion: @escaping () -> Void) throws {
        try repository.create(model: model)
        completion()
    }
}
