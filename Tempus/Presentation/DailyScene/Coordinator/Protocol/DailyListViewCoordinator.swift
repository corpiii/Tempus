//
//  DailyListViewCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/23.
//

protocol DailyListViewCoordinator: Coordinator, FinishDelegate, AnyObject {
    func pushInfoCreateViewController(fetchRefreshDelegate: FetchRefreshDelegate)
    func pushDetailViewController(originModel: DailyModel, fetchRefreshDelegate: FetchRefreshDelegate)
}
