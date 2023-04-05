//
//  BlockEditUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/31.
//

import Foundation

final class BlockEditUseCase {
    let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.update(model)
        completion()
    }
}
