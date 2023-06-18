//
//  DailyDetailCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/17.
//

import UIKit

final class DailyDetailCoordinator: Coordinator, FinishDelegate {
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .dailyDetail }
    
    private let navigationController: UINavigationController
    private let repository: DataManagerRepository
    
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    private weak var finishDelegate: FinishDelegate?
    private weak var startModeDelegate: StartModeDelegate?
    
    private let dailyDetailViewModel: DailyDetailViewModel
    private let dailyDetailViewController: DailyDetailViewController
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         originModel: DailyModel,
         finishDelegate: FinishDelegate,
         fetchRefreshDelegate: FetchRefreshDelegate,
         startModeDelegate: StartModeDelegate?) {
        self.navigationController = navigationController
        self.repository = repository
        
        self.finishDelegate = finishDelegate
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.startModeDelegate = startModeDelegate
        self.dailyDetailViewModel = .init(originModel: originModel)
        self.dailyDetailViewController = .init(viewModel: dailyDetailViewModel)
    }
    
    func start() {
        self.dailyDetailViewModel.coordinator = self
        self.navigationController.pushViewController(dailyDetailViewController, animated: true)
    }
    
    func finish(with startUseCase: DailyStartUseCase? = nil) {
        if let startUseCase {
            startModeDelegate?.startWith(startUseCase)
        }
        
        self.navigationController.popViewController(animated: true)
        finishDelegate?.finish(childCoordinator: self)
    }
    
    func pushDailyInfoEditViewController(originModel: DailyModel) {
        let dailyInfoEditCoordinator = DailyInfoEditCoordinator(navigationController: self.navigationController,
                                                                repository: self.repository,
                                                                originModel: originModel,
                                                                fetchRefreshDelegate: fetchRefreshDelegate,
                                                                finishDelegate: self,
                                                                editReflectDelegate: dailyDetailViewModel)
        dailyInfoEditCoordinator.start()
        childCoordinators.append(dailyInfoEditCoordinator)
    }
}
