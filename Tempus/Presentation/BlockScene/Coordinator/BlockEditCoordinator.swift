//
//  BlockEditCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/31.
//

import UIKit

class BlockEditCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .blockEdit }
    let navigationController: UINavigationController
    private let repository: DataManagerRepository
    private weak var finishDelegate: FinishDelegate?
    
    private let blockEditViewController: BlockEditViewController
    private let blockEditViewModel: BlockEditViewModel
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         originModel: BlockModel,
         fetchRefreshDelegate: FetchRefreshDelegate?,
         finishDelegate: FinishDelegate,
         editReflectDelegate: EditReflectDelegate) {
        self.navigationController = navigationController
        self.repository = repository
        self.finishDelegate = finishDelegate
        self.blockEditViewController = .init(nibName: nil, bundle: nil)
        self.blockEditViewModel = .init(originModel: originModel,
                                        repository: repository,
                                        fetchRefreshDelegate: fetchRefreshDelegate,
                                        editReflectDelegate: editReflectDelegate)
    }
    
    func start() {
        blockEditViewController.viewModel = blockEditViewModel
        blockEditViewModel.coordinator = self
        navigationController.pushViewController(blockEditViewController, animated: true)
    }
    
    func finish() {
        finishDelegate?.finish(childCoordinator: self)
    }
}
