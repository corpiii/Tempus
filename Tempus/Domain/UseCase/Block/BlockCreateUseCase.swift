//
//  BlockCreateUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/31.
//

import Foundation

final class BlockCreateUseCase {
    let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.create(model: model)
        completion()
    }
}
