//
//  DefaultBlockListViewCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/26.
//

import UIKit

final class DefaultBlockListViewCoordinator: BlockListViewCoordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { return .blockList }
    
    private let repository: DataManagerRepository
    private let blockListViewController: BlockListViewController
    private let blockListViewModel: BlockListViewModel
    private weak var startModeDelegate: StartModeDelegate?
    let navigationController: UINavigationController
    
    init(repository: DataManagerRepository, startModeDelegate: StartModeDelegate) {
        let tabBarImage = UIImage(systemName: "square.split.2x2")
        let tabBarSelectedImage = UIImage(systemName: "square.split.2x2.fill")
        let tabBarItem = UITabBarItem(title: nil, image: tabBarImage, selectedImage: tabBarSelectedImage)
        
        self.repository = repository
        
        self.blockListViewModel = BlockListViewModel(repository: repository)
        self.blockListViewController = BlockListViewController(viewModel: blockListViewModel)
        self.startModeDelegate = startModeDelegate
        self.navigationController = UINavigationController(rootViewController: blockListViewController)
        
        self.navigationController.tabBarItem = tabBarItem
    }
    
    func start() {
        self.blockListViewModel.coordinator = self
    }
    
    func pushCreateViewController(_ fetchRefreshDelegate: FetchRefreshDelegate) {
        let blockCreateCoordinator = DefaultBlockCreateCoordinator(navigationController: self.navigationController,
                                                                   repository: self.repository,
                                                                   fetchRefreshDelegate: self.blockListViewModel,
                                                                   finishDelegate: self,
                                                                   startModeDelegate: self.startModeDelegate)
        blockCreateCoordinator.start()
        childCoordinators.append(blockCreateCoordinator)
    }
    
    func pushDetailViewController(with model: BlockModel) {
        let blockDetailCoordinator = DefaultBlockDetailCoordinator(navigationController: self.navigationController,
                                                                   repository: self.repository,
                                                                   originModel: model,
                                                                   fetchRefreshDelegate: self.blockListViewModel,
                                                                   finishDelegate: self,
                                                                   startModeDelegate: self.startModeDelegate)
        blockDetailCoordinator.start()
        childCoordinators.append(blockDetailCoordinator)
    }
}
