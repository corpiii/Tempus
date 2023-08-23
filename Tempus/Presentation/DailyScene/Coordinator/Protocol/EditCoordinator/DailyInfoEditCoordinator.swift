//
//  DailyInfoEditCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/23.
//

protocol DailyInfoEditCoordinator: Coordinator {
    func finish()
    func pushDailyTimeDurationEditViewController(originModel: DailyModel)
}
