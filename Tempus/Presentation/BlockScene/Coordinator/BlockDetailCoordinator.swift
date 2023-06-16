//
//  BlockDetailCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/30.
//

import UIKit

final class BlockDetailCoordinator: Coordinator, FinishDelegate {
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .blockDetail }
    let navigationController: UINavigationController
    let repository: DataManagerRepository
    weak var fetchRefreshDelegate: FetchRefreshDelegate?
    weak var startModeDelegate: StartModeDelegate?
    weak var finishDelegate: FinishDelegate?
    
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

    
    func finish(with startUseCase: BlockStartUseCase? = nil) {
        if let startUseCase {
            startModeDelegate?.startWith(startUseCase)
        }
        
        self.navigationController.popViewController(animated: true)
        finishDelegate?.finish(childCoordinator: self)
    }
    
    func pushBlockEditViewController(with originModel: BlockModel) {
        let blockEditCoordinator = BlockEditCoordinator(navigationController: self.navigationController,
                                                        repository: self.repository,
                                                        originModel: originModel,
                                                        fetchRefreshDelegate: self.fetchRefreshDelegate,
                                                        finishDelegate: self,
                                                        editReflectDelegate: self.blockDetailViewModel)
        blockEditCoordinator.start()
        self.childCoordinators.append(blockEditCoordinator)
    }
}
