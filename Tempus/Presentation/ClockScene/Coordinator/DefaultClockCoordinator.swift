//
//  DefaultClockCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/26.
//

import UIKit

class DefaultClockCoordinator: ClockCoordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { return .clock }
    
    private weak var startApplyDelegate: StartApplyDelegate?
    
    let clockViewModel: ClockViewModel
    let clockViewController: ClockViewController
    
    init(startApplyDelegate: StartApplyDelegate) {
        let tabBarImage = UIImage(systemName: "clock")
        let tabBarSelectedImage = UIImage(systemName: "clock.fill")
        let tabBarItem = UITabBarItem(title: nil, image: tabBarImage, selectedImage: tabBarSelectedImage)
        
        self.clockViewModel = ClockViewModel()
        self.clockViewController = ClockViewController(viewModel: self.clockViewModel)
        self.clockViewController.tabBarItem = tabBarItem
        self.startApplyDelegate = startApplyDelegate
    }
    
    func start() {
        clockViewModel.coordinator = self
    }
    
    func startTimer() {
        startApplyDelegate?.transitionToClock()
    }
}
