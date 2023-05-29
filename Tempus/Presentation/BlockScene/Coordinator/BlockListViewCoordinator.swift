//
//  BlockListViewCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/26.
//

import UIKit

class BlockListViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { return .blockList }
    
    private let repository: DataManagerRepository
    private let blockListViewController: BlockListViewController
    private let blockListViewModel: BlockListViewModel
    let navigationController: UINavigationController
    
    init(repository: DataManagerRepository) {
        self.repository = repository
        
        self.blockListViewController = BlockListViewController(nibName: nil, bundle: nil)
        self.blockListViewModel = BlockListViewModel(repository: repository)
        self.navigationController = UINavigationController(rootViewController: blockListViewController)
        self.navigationController.tabBarItem = .init(tabBarSystemItem: .bookmarks, tag: 1)
    }
    
    func start() {
        self.blockListViewModel.coordinator = self
        blockListViewController.viewModel = self.blockListViewModel
    }
    
    func pushCreateViewController(_ fetchRefreshDelegate: FetchRefreshDelegate) {
        let blockCreateCoordinator = BlockCreateCoordinator(navigationController: navigationController,
                                                            repository: self.repository,
                                                            fetchRefreshDelegate: self.blockListViewModel,
                                                            finishDelegate: self)
        blockCreateCoordinator.start()
        childCoordinators.append(blockCreateCoordinator)
    }
}

extension BlockListViewCoordinator: FinishDelegate {
    func finish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        self.navigationController.popToRootViewController(animated: true)
    }
}
