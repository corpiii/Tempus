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
    private weak var startModeDelegate: StartModeDelegate?
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         finishDelegate: FinishDelegate,
         fetchRefreshDelegate: FetchRefreshDelegate?,
         startModeDelegate: StartModeDelegate?) {
        self.navigationController = navigationController
        self.dailyInfoCreateViewModel = DailyInfoCreateViewModel()
        self.dailyInfoCreateViewController = DailyInfoCreateViewController(viewModel: dailyInfoCreateViewModel)
        self.repository = repository
        self.finishDelegate = finishDelegate
        self.startModeDelegate = startModeDelegate
    }
    
    func start() {
        self.dailyInfoCreateViewModel.coordinator = self
        self.navigationController.pushViewController(dailyInfoCreateViewController, animated: true)
    }
    
    func pushTimeDurationCreateViewController(modelTitle: String,
                                              focusTime: Double,
                                              breakTime: Double) {
        let dailyTimeDurationCreateCoordinator = DailyTimeDurationCreateCoordinator(navigationController: self.navigationController,
                                                                                    modelTitle: modelTitle,
                                                                                    focusTime: focusTime,
                                                                                    breakTime: breakTime,
                                                                                    repository: self.repository,
                                                                                    fetchRefreshDelegate: fetchRefreshDelegate,
                                                                                    finishDelegate: self,
                                                                                    startModeDelegate: startModeDelegate)
        dailyTimeDurationCreateCoordinator.start()
        childCoordinators.append(dailyTimeDurationCreateCoordinator)
    }
    
    func finish() {
        finishDelegate?.finish(childCoordinator: self)
    }
}

extension DailyInfoCreateCoordinator: FinishDelegate {
    func finish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        self.navigationController.popToRootViewController(animated: true)
    }
}
