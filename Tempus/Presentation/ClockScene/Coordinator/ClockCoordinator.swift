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
    let clockViewModel: ClockViewModel
    let clockViewController: ClockViewController
    private weak var startApplyDelegate: StartApplyDelegate?
    
    init(startApplyDelegate: StartApplyDelegate) {
        self.clockViewModel = ClockViewModel()
        self.clockViewController = ClockViewController(viewModel: self.clockViewModel)
        self.clockViewController.tabBarItem = .init(tabBarSystemItem: .downloads, tag: 0)
        self.startApplyDelegate = startApplyDelegate
    }
    
    func start() {
        clockViewModel.coordinator = self
    }
    
    func startTimer() {
        startApplyDelegate?.transitionToClock()
    }
}
