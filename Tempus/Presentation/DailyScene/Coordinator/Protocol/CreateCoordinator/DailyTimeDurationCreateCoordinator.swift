//
//  DailyTimeDurationCreateCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/23.
//

protocol DailyTimeDurationCreateCoordinator: Coordinator, FinishDelegate {
    func finish()
    func completeFinish(with startUseCase: DailyStartUseCase?)
}
