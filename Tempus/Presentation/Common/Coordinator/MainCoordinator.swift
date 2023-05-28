//
//  MainCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/26.
//

import UIKit

class MainCoordinator: Coordinator {
    let tabbarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    
    private let repository: DataManagerRepository
    
    init(_ tabbarController: UITabBarController, _ repository: DataManagerRepository) {
        self.tabbarController = tabbarController
        self.repository = repository
        
        // clockViewCon
        let clockViewController = ClockViewController(nibName: nil, bundle: nil)
        let clockViewModel = ClockViewModel()
        let clockCoordinator = ClockCoordinator(viewController: clockViewController)
        
        clockViewController.viewModel = clockViewModel
        clockViewModel.coordinator = clockCoordinator
        
        clockViewController.tabBarItem = .init(tabBarSystemItem: .downloads, tag: 0)
        childCoordinators.append(clockCoordinator)
        
        // blockViewCon
        let blockListViewController = BlockListViewController(nibName: nil, bundle: nil)
        let blockListViewModel = BlockListViewModel(repository: repository)
        let blockListNavigationViewController = UINavigationController(rootViewController: blockListViewController)
        let blockListViewCoordinator = BlockListViewCoordinator(blockListNavigationViewController, repository)
        
        blockListViewController.viewModel = blockListViewModel
        blockListViewModel.coordinator = blockListViewCoordinator
        
        blockListNavigationViewController.tabBarItem = .init(tabBarSystemItem: .bookmarks, tag: 1)
        childCoordinators.append(blockListViewCoordinator)
        
        // dailyViewCon
        
        // timerViewCon
        
        tabbarController.setViewControllers([clockViewController, blockListNavigationViewController], animated: true)
    }
    
    func startClockFlow() {
        tabbarController.selectedIndex = 0
    }
    
    func startBlockFlow() {
        tabbarController.selectedIndex = 1
    }
}
