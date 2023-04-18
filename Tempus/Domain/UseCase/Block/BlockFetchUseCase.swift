//
//  BlockFetchUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/18.
//

import Foundation

final class BlockFetchUseCase {
    let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func execute(_ completion: @escaping ([BlockModel]) -> Void) throws {
        let models = try repository.fetchAllBlockModel()
        
        completion(models)
    }
}
