//
//  TimerCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/20.
//

import UIKit

final class TimerCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .timer }
    
    let navigationController: UINavigationController
    private let timerViewModel: TimerViewModel
    private let timerViewController: TimerViewController
    private weak var startModeDelegate: StartModeDelegate?
    
    init(startModeDelegate: StartModeDelegate) {
        let tabBarImage = UIImage(systemName: "timer")
        let tabBarItem = UITabBarItem(title: nil, image: tabBarImage, selectedImage: nil)
        
        self.timerViewModel = .init()
        self.timerViewController = .init(viewModel: timerViewModel)
        self.navigationController = .init(rootViewController: timerViewController)
        self.navigationController.tabBarItem = tabBarItem
        self.startModeDelegate = startModeDelegate
    }
    
    func start() {
        timerViewModel.coordinator = self
    }
    
    func modeStart(_ startUseCase: TimerStartUseCase) {
        startModeDelegate?.startWith(startUseCase)
    }
}
