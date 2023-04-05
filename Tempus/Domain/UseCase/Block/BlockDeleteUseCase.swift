//
//  BlockDeleteUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/01.
//

import Foundation

final class BlockDeleteUseCase {
    let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.delete(model)
        completion()
    }
}
