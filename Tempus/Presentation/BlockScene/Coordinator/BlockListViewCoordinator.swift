//
//  BlockListViewCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/26.
//

import UIKit

final class BlockListViewCoordinator: Coordinator, FinishDelegate {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { return .blockList }
    
    private let repository: DataManagerRepository
    private let blockListViewController: BlockListViewController
    private let blockListViewModel: BlockListViewModel
    private weak var startModeDelegate: StartModeDelegate?
    let navigationController: UINavigationController
    
    init(repository: DataManagerRepository, startModeDelegate: StartModeDelegate) {
        self.repository = repository
        
        self.blockListViewModel = BlockListViewModel(repository: repository)
        self.blockListViewController = BlockListViewController(viewModel: blockListViewModel)
        self.startModeDelegate = startModeDelegate
        self.navigationController = UINavigationController(rootViewController: blockListViewController)
        self.navigationController.tabBarItem = .init(tabBarSystemItem: .bookmarks, tag: 1)
    }
    
    func start() {
        self.blockListViewModel.coordinator = self
    }
    
    func pushCreateViewController(_ fetchRefreshDelegate: FetchRefreshDelegate) {
        let blockCreateCoordinator = BlockCreateCoordinator(navigationController: self.navigationController,
                                                            repository: self.repository,
                                                            fetchRefreshDelegate: self.blockListViewModel,
                                                            finishDelegate: self,
                                                            startModeDelegate: self.startModeDelegate)
        blockCreateCoordinator.start()
        childCoordinators.append(blockCreateCoordinator)
    }
    
    func pushDetailViewController(with model: BlockModel) {
        let blockDetailCoordinator = BlockDetailCoordinator(navigationController: self.navigationController,
                                                            repository: self.repository,
                                                            originModel: model,
                                                            fetchRefreshDelegate: self.blockListViewModel,
                                                            finishDelegate: self,
                                                            startModeDelegate: self.startModeDelegate)
        blockDetailCoordinator.start()
        childCoordinators.append(blockDetailCoordinator)
    }
}
