//
//  DefaultDailyTimeDurationEditCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/20.
//

import UIKit

final class DefaultDailyTimeDurationEditCoordinator: DailyTimeDurationEditCoordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .dailyTimeDurationEdit }
    
    private let navigationController: UINavigationController
    private let repository: DataManagerRepository
    
    private weak var editReflectDelegate: EditReflectDelegate?
    private weak var finishDelegate: DailyFinishDelegate?
    
    private let dailyTimeDurationEditViewModel: DailyTimeDurationEditViewModel
    private let dailyTimeDurationEditViewController: DailyTimeDurationEditViewController
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         finishDelegate: DailyFinishDelegate?,
         originModel: DailyModel,
         fetchRefreshDelegate: FetchRefreshDelegate?,
         editReflectDelegate: EditReflectDelegate?) {
        self.navigationController = navigationController
        self.repository = repository
        self.finishDelegate = finishDelegate
        dailyTimeDurationEditViewModel = DefaultDailyTimeDurationEditViewModel(originModel: originModel,
                                                                               repository: repository,
                                                                               fetchRefreshDelegate: fetchRefreshDelegate,
                                                                               editReflectDelegate: editReflectDelegate)
        dailyTimeDurationEditViewController = .init(viewModel: dailyTimeDurationEditViewModel)
    }
    
    func start() {
        dailyTimeDurationEditViewModel.coordinator = self
        navigationController.pushViewController(dailyTimeDurationEditViewController, animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
        finishDelegate?.finish(childCoordinator: self)
    }
    
    func completeFinish() {
        finishDelegate?.completeFinish(childCoordinator: self)
    }
}
