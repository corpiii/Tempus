//
//  BlockCreateCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/28.
//

import UIKit

final class BlockCreateCoordinator: Coordinator, FinishDelegate {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { return .blockCreate }
    let navigationController: UINavigationController
    private let repository: DataManagerRepository

    private let blockCreateViewModel: BlockCreateViewModel
    private let blockCreateViewController: BlockCreateViewController
    private let blockCreateNavigationController: UINavigationController
    
    weak var finishDelegate: FinishDelegate?
    private weak var startModeDelegate: StartModeDelegate?
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         fetchRefreshDelegate: FetchRefreshDelegate,
         finishDelegate: FinishDelegate,
         startModeDelegate: StartModeDelegate?) {
        self.navigationController = navigationController
        self.repository = repository
        self.blockCreateViewModel = BlockCreateViewModel(repository: self.repository,
                                                         fetchRefreshDelegate: fetchRefreshDelegate)
        self.blockCreateViewController = BlockCreateViewController(viewModel: self.blockCreateViewModel)
        self.blockCreateNavigationController = UINavigationController(rootViewController: blockCreateViewController)
        self.finishDelegate = finishDelegate
        self.startModeDelegate = startModeDelegate
    }
    
    func start() {
        self.blockCreateViewModel.coordinator = self
        self.navigationController.present(blockCreateNavigationController, animated: true)
    }
    
    func finish(with startUseCase: BlockStartUseCase? = nil) {
        if let startUseCase {
            startModeDelegate?.startWith(startUseCase)
        }
        
        self.blockCreateNavigationController.dismiss(animated: true)
        finishDelegate?.finish(childCoordinator: self)
    }
}
