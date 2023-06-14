//
//  FinishDelegate.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/28.
//

protocol FinishDelegate: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    func finish(childCoordinator: Coordinator)
}

extension FinishDelegate {
    func finish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
    }
}
