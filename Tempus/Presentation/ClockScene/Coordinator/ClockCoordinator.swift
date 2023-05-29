//
//  ClockCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/26.
//

import UIKit

class ClockCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { return .clock }
    let clockViewController: ClockViewController
    let clockViewModel: ClockViewModel
    private weak var startApplyDelegate: StartApplyDelegate?
    
    init(startApplyDelegate: StartApplyDelegate) {
        self.clockViewController = ClockViewController(nibName: nil, bundle: nil)
        self.clockViewController.tabBarItem = .init(tabBarSystemItem: .downloads, tag: 0)
        self.clockViewModel = ClockViewModel()
        self.startApplyDelegate = startApplyDelegate
    }
    
    func start() {
        self.clockViewController.viewModel = clockViewModel
        clockViewModel.coordinator = self
    }
    
    func startTimer() {
        startApplyDelegate?.transitionToClock()
    }
}
