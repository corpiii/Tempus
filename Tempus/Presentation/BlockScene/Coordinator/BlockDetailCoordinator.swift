//
//  BlockDetailCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/30.
//

import UIKit

class BlockDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .blockDetail }
    let navigationController: UINavigationController
    let repository: DataManagerRepository
    weak var fetchRefreshDelegate: FetchRefreshDelegate?
    weak var startModeDelegate: StartModeDelegate?
    weak var finishDelegate: FinishDelegate?
    
    private let blockDetailViewModel: BlockDetailViewModel
    private let blockDetailViewController: BlockDetailViewController
    private let blockDetailNavigationController: UINavigationController
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         originModel: BlockModel,
         fetchRefreshDelegate: FetchRefreshDelegate,
         finishDelegate: FinishDelegate,
         startModeDelegate: StartModeDelegate?) {
        self.navigationController = navigationController
        self.repository = repository
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.finishDelegate = finishDelegate
        self.startModeDelegate = startModeDelegate
        self.blockDetailViewModel = .init(originModel: originModel)
        self.blockDetailViewController = .init(viewModel: self.blockDetailViewModel)
        self.blockDetailNavigationController = .init(rootViewController: self.blockDetailViewController)
    }
    
    func start() {
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
    
    func pushBlockEditViewController(with originModel: BlockModel) {
        let blockEditCoordinator = BlockEditCoordinator(navigationController: self.blockDetailNavigationController,
                                                        repository: self.repository,
                                                        originModel: originModel,
                                                        fetchRefreshDelegate: self.fetchRefreshDelegate,
                                                        finishDelegate: self,
                                                        editReflectDelegate: self.blockDetailViewModel)
        blockEditCoordinator.start()
        self.childCoordinators.append(blockEditCoordinator)
    }
}

extension BlockDetailCoordinator: FinishDelegate {
    func finish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        self.blockDetailNavigationController.popToRootViewController(animated: true)
    }
}
