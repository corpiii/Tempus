//
//  BlockListViewCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/26.
//

import UIKit

class BlockListViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let repository: DataManagerRepository
    
    init(_ navigationController: UINavigationController, _ repostiroy: DataManagerRepository) {
        self.navigationController = navigationController
        self.repository = repostiroy
    }
    
    func pushCreateViewController(_ fetchRefreshDelegate: FetchRefreshDelegate) {
        let blockCreateViewController = BlockCreateViewController(nibName: nil, bundle: nil)
        let blockCreateViewModel = BlockCreateViewModel(repository: repository,
                                                        fetchRefreshDelegate: fetchRefreshDelegate)
        let blockCreateCoordinator = BlockCreateCoordinator()
        
        blockCreateViewController.viewModel = blockCreateViewModel
        blockCreateViewModel.coordinator = blockCreateCoordinator
        childCoordinators.append(blockCreateCoordinator)
        self.navigationController.pushViewController(blockCreateViewController, animated: true)
    }
}
