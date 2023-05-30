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
    }
    
    func start() {
        let navigationController = UINavigationController(rootViewController: blockDetailViewController)
        
        self.blockDetailViewController.viewModel = self.blockDetailViewModel
        self.blockDetailViewModel.coordinator = self
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController.present(navigationController, animated: true)
    }
    
    func finish(with startUseCase: BlockStartUseCase? = nil) {
        if let startUseCase {
            startModeDelegate?.startWith(startUseCase)
        }
        
        finishDelegate?.finish(childCoordinator: self)
    }
    
    func pushBlockEditViewController() {
        // TODO
    }
}
