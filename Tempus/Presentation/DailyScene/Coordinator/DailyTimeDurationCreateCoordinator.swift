//
//  DailyTimeDurationCreateCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/13.
//

import UIKit

final class DailyTimeDurationCreateCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .dailyTimeDurationCreate }
    
    let dailyTimeDurationCreateViewController: DailyTimeDurationCreateViewController
    let dailyTimeDurationCreateViewModel: DailyTimeDurationCreateViewModel
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController,
         modelTitle: String,
         focusTime: Double,
         breakTime: Double,
         repository: DataManagerRepository,
         fetchRefreshDelegate: FetchRefreshDelegate?) {
        self.navigationController = navigationController
        dailyTimeDurationCreateViewModel = .init(modelTitle: modelTitle,
                                                 focusTime: focusTime,
                                                 breakTime: breakTime,
                                                 repository: repository,
                                                 fetchRefreshDelgate: fetchRefreshDelegate)
        dailyTimeDurationCreateViewController = .init(viewModel: dailyTimeDurationCreateViewModel,
                                                      focusTime: focusTime,
                                                      breakTime: breakTime)
    }
    
    func start() {
        dailyTimeDurationCreateViewModel.coordinator = self
        navigationController.pushViewController(dailyTimeDurationCreateViewController, animated: true)
    }
}
