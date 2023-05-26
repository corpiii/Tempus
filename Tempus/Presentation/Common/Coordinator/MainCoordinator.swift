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
        clockViewController.viewModel = clockViewModel
        
        /*
         clockCoordinator and append in childCoordinators
         */
        
        // blockViewCon
        let blockListViewController = BlockListViewController(nibName: nil, bundle: nil)
        let blockListViewModel = BlockListViewModel(repository: repository)
        let blockListNavigationViewController = UINavigationController(rootViewController: blockListViewController)
        let blockListViewCoordinator = BlockListViewCoordinator(blockListNavigationViewController)
        
        blockListViewController.viewModel = blockListViewModel
        blockListNavigationViewController.tabBarItem = .init(tabBarSystemItem: .bookmarks, tag: 0)
        childCoordinators.append(blockListViewCoordinator)
        
        // dailyViewCon
        
        // timerViewCon
        
        tabbarController.setViewControllers([clockViewController, blockListNavigationViewController], animated: true)
    }
    
    func start() {
        startClockFlow()
    }
}

private extension MainCoordinator {
    func startClockFlow() {
        tabbarController.selectedIndex = 0
    }
    
    func startBlockFlow() {
        tabbarController.selectedIndex = 1
    }
}
