//
//  MainCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/26.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { return .main }

    private let tabBarController: UITabBarController
    
    private let repository: DataManagerRepository
    
    init(_ tabBarController: UITabBarController, _ repository: DataManagerRepository) {
        self.tabBarController = tabBarController
        tabBarController.tabBar.tintColor = ColorConstant.secondColor
        self.repository = repository
        
        // clockCoordinator
        let clockCoordinator = DefaultClockCoordinator(startApplyDelegate: self)
        childCoordinators.append(clockCoordinator)
        
        // blockListCoordinator
        let blockListViewCoordinator = DefaultBlockListViewCoordinator(repository: repository,
                                                                startModeDelegate: clockCoordinator.clockViewModel)
        childCoordinators.append(blockListViewCoordinator)
        
        // dailyListCoordinator
        let dailyListViewCoordinator = DefaultDailyListViewCoordinator(repository: repository,
                                                                startModeDelegate: clockCoordinator.clockViewModel)
        childCoordinators.append(dailyListViewCoordinator)
        
        // timerCoordinator
        let timerCoordinator = DefaultTimerCoordinator(startModeDelegate: clockCoordinator.clockViewModel)
        childCoordinators.append(timerCoordinator)
        
        tabBarController.setViewControllers([clockCoordinator.clockViewController,
                                             blockListViewCoordinator.navigationController,
                                             dailyListViewCoordinator.navigationController,
                                             timerCoordinator.navigationController], animated: true)
    }
    
    func start() {
        childCoordinators.forEach { coordinator in
            coordinator.start()
        }
    }
}

extension MainCoordinator: StartApplyDelegate {
    func transitionToClock() {
        tabBarController.selectedIndex = 0
    }
}
