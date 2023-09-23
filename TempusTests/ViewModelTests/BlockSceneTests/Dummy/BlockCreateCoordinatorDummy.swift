//
//  BlockCreateCoordinatorDummy.swift
//  TempusTests
//
//  Created by 이정민 on 2023/09/23.
//

import Foundation

class BlockCreateCoordinatorDummy: BlockCreateCoordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .blockCreate }
    
    func start() { }
    
    func finish(with startUseCase: BlockStartUseCase?) { }
}
