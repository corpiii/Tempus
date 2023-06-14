//
//  BlockEditCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/31.
//

import UIKit

final class BlockEditCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .blockEdit }
    let navigationController: UINavigationController
    private let repository: DataManagerRepository
    private weak var finishDelegate: FinishDelegate?
    private let blockEditViewModel: BlockEditViewModel
    private let blockEditViewController: BlockEditViewController
    
    init(navigationController: UINavigationController,
         repository: DataManagerRepository,
         originModel: BlockModel,
         fetchRefreshDelegate: FetchRefreshDelegate?,
         finishDelegate: FinishDelegate,
         editReflectDelegate: EditReflectDelegate) {
        self.navigationController = navigationController
        self.repository = repository
        self.finishDelegate = finishDelegate
        self.blockEditViewModel = .init(originModel: originModel,
                                        repository: repository,
                                        fetchRefreshDelegate: fetchRefreshDelegate,
                                        editReflectDelegate: editReflectDelegate)
        self.blockEditViewController = .init(viewModel: self.blockEditViewModel)
    }
    
    func start() {
        blockEditViewModel.coordinator = self
        navigationController.pushViewController(blockEditViewController, animated: true)
    }
    
    func finish() {
        finishDelegate?.finish(childCoordinator: self)
    }
}
