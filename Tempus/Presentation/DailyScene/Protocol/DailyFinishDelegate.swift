//
//  DailyFinishDelegate.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/16.
//

import Foundation

protocol DailyFinishDelegate: FinishDelegate {
    func completeFinish(childCoordinator: Coordinator)
}
