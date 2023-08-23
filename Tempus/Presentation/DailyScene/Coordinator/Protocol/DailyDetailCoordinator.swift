//
//  DailyDetailCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/23.
//

protocol DailyDetailCoordinator: Coordinator, FinishDelegate {
    func finish(with startUseCase: DailyStartUseCase?)
    func pushDailyInfoEditViewController(originModel: DailyModel)
}
