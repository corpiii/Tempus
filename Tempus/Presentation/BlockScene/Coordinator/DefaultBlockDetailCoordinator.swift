//
//  DefaultBlockDetailCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/30.
//

import UIKit

final class DefaultBlockDetailCoordinator: BlockDetailCoordinator {
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .blockDetail }
    private let navigationController: UINavigationController
    private let repository: DataManagerRepository
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    private weak var startModeDelegate: StartModeDelegate?
    private weak var finishDelegate: FinishDelegate?
    
    private let blockDetailViewModel: BlockDetailViewModel
    private let blockDetailViewController: BlockDetailViewController
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         originModel: BlockModel,
         fetchRefreshDelegate: FetchRefreshDelegate,
         finishDelegate: FinishDelegate,
         startModeDelegate: StartModeDelegate?) {
        self.navigationController = navigationController
        self.repository = repository
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.startModeDelegate = startModeDelegate
        self.finishDelegate = finishDelegate
        self.blockDetailViewModel = .init(originModel: originModel)
        self.blockDetailViewController = .init(viewModel: self.blockDetailViewModel)
    }
    
    func start() {
        self.blockDetailViewModel.coordinator = self
        self.navigationController.pushViewController(blockDetailViewController, animated: true)
    }

    
    func finish(with startUseCase: BlockStartUseCase?) {
        if let startUseCase {
            startModeDelegate?.startWith(startUseCase)
        }
        
        self.navigationController.popViewController(animated: true)
        finishDelegate?.finish(childCoordinator: self)
    }
    
    func pushBlockEditViewController(with originModel: BlockModel) {
        let blockEditCoordinator = DefaultBlockEditCoordinator(navigationController: self.navigationController,
                                                               repository: self.repository,
                                                               originModel: originModel,
                                                               fetchRefreshDelegate: self.fetchRefreshDelegate,
                                                               finishDelegate: self,
                                                               editReflectDelegate: self.blockDetailViewModel)
        blockEditCoordinator.start()
        self.childCoordinators.append(blockEditCoordinator)
    }
}
