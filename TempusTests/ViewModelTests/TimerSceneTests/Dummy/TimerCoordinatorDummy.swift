//
//  TimerCoordinatorDummy.swift
//  TempusTests
//
//  Created by 이정민 on 2023/09/23.
//

class TimerCoordinatorDummy: TimerCoordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .timer }
        
    func finish(_ startUseCase: TimerStartUseCase) { }
    func start() { }
}
