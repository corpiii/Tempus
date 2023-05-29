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
    
    init() {
        self.clockViewController = ClockViewController(nibName: nil, bundle: nil)
        self.clockViewController.tabBarItem = .init(tabBarSystemItem: .downloads, tag: 0)
        self.clockViewController.viewModel = ClockViewModel()
    }
    
    func start() {
    }
}
