//
//  DefaultDailyInfoCreateCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/07.
//

import UIKit

final class DefaultDailyInfoCreateCoordinator: DailyInfoCreateCoordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .dailyInfoCreate }
    
    private let navigationController: UINavigationController
    private let dailyInfoCreateViewModel: DailyInfoCreateViewModel
    private let dailyInfoCreateViewController: DailyInfoCreateViewController
    private let dailyInfoCreateNavigationController: UINavigationController
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
        self.dailyInfoCreateNavigationController = UINavigationController(rootViewController: dailyInfoCreateViewController)
        self.repository = repository
        self.finishDelegate = finishDelegate
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.startModeDelegate = startModeDelegate
    }
    
    func start() {
        self.dailyInfoCreateViewModel.coordinator = self
        self.dailyInfoCreateNavigationController.modalPresentationStyle = .fullScreen
        self.navigationController.present(self.dailyInfoCreateNavigationController, animated: true)
    }
    
    func pushTimeDurationCreateViewController(modelTitle: String,
                                              focusTime: Double,
                                              breakTime: Double) {
        let dailyTimeDurationCreateCoordinator = DefaultDailyTimeDurationCreateCoordinator(navigationController: self.dailyInfoCreateNavigationController,
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
        self.dailyInfoCreateNavigationController.dismiss(animated: true)
        finishDelegate?.finish(childCoordinator: self)
    }
}

extension DefaultDailyInfoCreateCoordinator: DailyFinishDelegate {
    func completeFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        self.finish()
    }
}
