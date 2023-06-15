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
    private weak var finishDelegate: FinishDelegate?
    private weak var startModeDelegate: StartModeDelegate?
    
    init(navigationController: UINavigationController,
         modelTitle: String,
         focusTime: Double,
         breakTime: Double,
         repository: DataManagerRepository,
         fetchRefreshDelegate: FetchRefreshDelegate?,
         finishDelegate: FinishDelegate?,
         startModeDelegate: StartModeDelegate?) {
        self.navigationController = navigationController
        dailyTimeDurationCreateViewModel = .init(modelTitle: modelTitle,
                                                 focusTime: focusTime,
                                                 breakTime: breakTime,
                                                 repository: repository,
                                                 fetchRefreshDelgate: fetchRefreshDelegate)
        dailyTimeDurationCreateViewController = .init(viewModel: dailyTimeDurationCreateViewModel,
                                                      focusTime: focusTime,
                                                      breakTime: breakTime)
        self.finishDelegate = finishDelegate
        self.startModeDelegate = startModeDelegate
    }
    
    func start() {
        dailyTimeDurationCreateViewModel.coordinator = self
        navigationController.pushViewController(dailyTimeDurationCreateViewController, animated: true)
    }
    
    func finish(with startUseCase: DailyStartUseCase? = nil) {
        if let startUseCase {
            startModeDelegate?.startWith(startUseCase)
        }
        
        self.navigationController.popViewController(animated: true)
        finishDelegate?.finish(childCoordinator: self)
    }
}
