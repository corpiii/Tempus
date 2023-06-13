//
//  DailyInfoCreateCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/07.
//

import UIKit

final class DailyInfoCreateCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .dailyInfoCreate }
    
    private let dailyInfoCreateViewController: DailyInfoCreateViewController
    private let dailyInfoCreateViewModel: DailyInfoCreateViewModel
    private let repository: DataManagerRepository
    private weak var finishDelegate: FinishDelegate?
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         finishDelegate: FinishDelegate,
         fetchRefreshDelegate: FetchRefreshDelegate?) {
        self.navigationController = navigationController
        self.dailyInfoCreateViewModel = DailyInfoCreateViewModel()
        self.dailyInfoCreateViewController = DailyInfoCreateViewController(viewModel: dailyInfoCreateViewModel)
        self.repository = repository
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        self.dailyInfoCreateViewModel.coordinator = self
        self.navigationController.pushViewController(dailyInfoCreateViewController, animated: true)
    }
    
    func pushTimeDurationCreateViewController(modelTitle: String,
                                              focusTime: Double,
                                              breakTime: Double,
                                              fetchRefreshDelegate: FetchRefreshDelegate) {
        let dailyTimeDurationCreateCoordinator = DailyTimeDurationCreateCoordinator(navigationController: UINavigationController
                                                                                    modelTitle: modelTitle,
                                                                                    focusTime: focusTime,
                                                                                    breakTime: breakTime,
                                                                                    repository: self.repository,
                                                                                    FetchRefreshDelegate: fetchRefreshDelegate)
        
        dailyTimeDurationCreateCoordinator.start()
        childCoordinators.append(dailyTimeDurationCreateCoordinator)
    }
}
