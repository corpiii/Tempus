//
//  BlockCreateUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/31.
//

import Foundation

class BlockCreateUseCase {
    let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func execute(title: String, divideCount: Double, _ completion: @escaping () -> Void) throws {
        let model = BlockModel(id: UUID(), divideCount: divideCount)
        
        try repository.create(model: model)
        
        completion()
    }
}
