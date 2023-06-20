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
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         originModel: DailyModel,
         fetchRefreshDelegate: FetchRefreshDelegate,
         editReflectDelegate: EditReflectDelegate) {
        self.navigationController = navigationController
        self.repository = repository
        dailyTimeDurationEditViewModel = .init(originModel: originModel,
                                               repository: repository,
                                               fetchRefreshDelegate: fetchRefreshDelegate,
                                               editReflectDelegate: editReflectDelegate)
        dailyTimeDurationEditViewController = .init(viewModel: dailyTimeDurationEditViewModel,
                                                    focusTime: originModel.focusTime,
                                                    breakTime: originModel.breakTime)
    }
    
    func start() {
        dailyTimeDurationEditViewModel.coordinator = self
        navigationController.pushViewController(dailyTimeDurationEditViewController, animated: true)
    }
}
