//
//  DailyTimeDurationEditCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/20.
//

import UIKit

final class DailyTimeDurationEditCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .dailyTimeDurationEdit }
    
    private let navigationController: UINavigationController
    private let repository: DataManagerRepository
    private let dailyTimeDurationEditViewController: DailyTimeDurationEditViewController
    private let dailyTimeDurationEditViewModel: DailyTimeDurationEditViewModel
    
    private weak var editReflectDelegate: EditReflectDelegate?
    private weak var finishDelegate: DailyFinishDelegate?
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         finishDelegate: DailyFinishDelegate?,
         originModel: DailyModel,
         fetchRefreshDelegate: FetchRefreshDelegate?,
         editReflectDelegate: EditReflectDelegate?) {
        self.navigationController = navigationController
        self.repository = repository
        self.finishDelegate = finishDelegate
        dailyTimeDurationEditViewModel = .init(originModel: originModel,
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
}
