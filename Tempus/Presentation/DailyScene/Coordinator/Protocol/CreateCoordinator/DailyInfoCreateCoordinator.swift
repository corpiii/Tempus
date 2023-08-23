//
//  DailyInfoCreateCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/23.
//

protocol DailyInfoCreateCoordinator: Coordinator, FinishDelegate {
    func pushTimeDurationCreateViewController(modelTitle: String,
                                              focusTime: Double,
                                              breakTime: Double)
    func finish()
}
