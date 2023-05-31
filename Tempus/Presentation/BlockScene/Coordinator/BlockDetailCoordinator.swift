//
//  BlockDetailCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/30.
//

import UIKit

class BlockDetailCoordinator: Coordinator, FinishDelegate {
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .blockDetail }
    let navigationController: UINavigationController
    let repository: DataManagerRepository
    let originModel: BlockModel
    weak var fetchRefreshDelegate: FetchRefreshDelegate?
    weak var startModeDelegate: StartModeDelegate?
    weak var finishDelegate: FinishDelegate?
    
    let blockDetailViewController: BlockDetailViewController
    let blockDetailViewModel: BlockDetailViewModel
    let blockDetailNavigationController: UINavigationController
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         originModel: BlockModel,
         fetchRefreshDelegate: FetchRefreshDelegate,
         finishDelegate: FinishDelegate,
         startModeDelegate: StartModeDelegate?) {
        self.navigationController = navigationController
        self.repository = repository
        self.originModel = originModel
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.finishDelegate = finishDelegate
        self.startModeDelegate = startModeDelegate
        self.blockDetailViewController = .init(nibName: nil, bundle: nil)
        self.blockDetailViewModel = .init(originModel: originModel)
        self.blockDetailNavigationController = .init(rootViewController: self.blockDetailViewController)
    }
    
    func start() {
        self.blockDetailViewController.viewModel = self.blockDetailViewModel
        self.blockDetailViewModel.coordinator = self
        blockDetailNavigationController.modalPresentationStyle = .fullScreen
        self.navigationController.present(blockDetailNavigationController, animated: true)
    }
    
    func finish(with startUseCase: BlockStartUseCase? = nil) {
        if let startUseCase {
            startModeDelegate?.startWith(startUseCase)
        }
        
        self.blockDetailNavigationController.dismiss(animated: true)
        finishDelegate?.finish(childCoordinator: self)
    }
    
    func pushBlockEditViewController() {
        let blockEditCoordinator = BlockEditCoordinator(navigationController: self.blockDetailNavigationController,
                                                        repository: self.repository,
                                                        originModel: self.originModel,
                                                        fetchRefreshDelegate: self.fetchRefreshDelegate,
                                                        finishDelegate: self,
                                                        editReflectDelegate: self.blockDetailViewModel)
        blockEditCoordinator.start()
        self.childCoordinators.append(blockEditCoordinator)
    }
}
