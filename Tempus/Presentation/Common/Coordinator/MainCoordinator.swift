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
        self.repository = repository
        
        // clockViewCon
        let clockCoordinator = ClockCoordinator(startApplyDelegate: self)
        clockCoordinator.start()
        childCoordinators.append(clockCoordinator)
        
        // blockViewCon
        let blockListViewCoordinator = BlockListViewCoordinator(repository: repository,
                                                                startModeDelegate: clockCoordinator.clockViewModel)
        blockListViewCoordinator.start()
        childCoordinators.append(blockListViewCoordinator)
        
        // dailyViewCon
        
        // timerViewCon
        
        tabBarController.setViewControllers([clockCoordinator.clockViewController,
                                             blockListViewCoordinator.navigationController], animated: true)
    }
}

extension MainCoordinator: StartApplyDelegate {
    func transitionToClock() {
        tabBarController.selectedIndex = 0
    }
}
