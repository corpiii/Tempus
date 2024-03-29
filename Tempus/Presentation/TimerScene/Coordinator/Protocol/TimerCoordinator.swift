//
//  TimerCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/23.
//

protocol TimerCoordinator: Coordinator, AnyObject {
    func finish(_ startUseCase: TimerStartUseCase)
}
