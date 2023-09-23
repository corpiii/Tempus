//
//  ClockCoordinatorDummy.swift
//  TempusTests
//
//  Created by 이정민 on 2023/09/07.
//

class ClockCoordinatorDummy: ClockCoordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .clock }
    
    func startTimer() { }
    func start() { }
}
