//
//  BlockCreateCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/28.
//

import UIKit

class BlockCreateCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { return .blockCreate }
    weak var finishDelegate: FinishDelegate?
    private let repository: DataManagerRepository
    private let navigationController: UINavigationController

    private let blockCreateViewController: BlockCreateViewController
    private let blockCreateViewModel: BlockCreateViewModel
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         fetchRefreshDelegate: FetchRefreshDelegate,
         finishDelegate: FinishDelegate) {
        self.navigationController = navigationController
        self.repository = repository
        self.blockCreateViewModel = BlockCreateViewModel(repository: self.repository,
                                                        fetchRefreshDelegate: fetchRefreshDelegate)
        blockCreateViewController = BlockCreateViewController(nibName: nil, bundle: nil)
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        self.blockCreateViewModel.coordinator = self
        self.blockCreateViewController.viewModel = blockCreateViewModel
        navigationController.pushViewController(self.blockCreateViewController, animated: true)
    }
    
    func finish() {
        finishDelegate?.finish(childCoordinator: self)
    }
}
