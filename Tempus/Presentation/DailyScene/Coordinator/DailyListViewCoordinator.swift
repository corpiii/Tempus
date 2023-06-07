//
//  DailyListViewCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/04.
//

import UIKit

final class DailyListViewCoordinator: Coordinator, FinishDelegate {
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .dailyList }
    
    private let repository: DataManagerRepository
    private let dailyListViewModel: DailyListViewModel
    private let dailyListViewController: DailyListViewController
    private weak var startModeDelegate: StartModeDelegate?
    let navigationController: UINavigationController
    
    init(repository: DataManagerRepository, startModeDelegate: StartModeDelegate) {
        self.repository = repository
        self.dailyListViewModel = .init(repository: self.repository)
        self.dailyListViewController = .init(viewModel: self.dailyListViewModel)
        self.startModeDelegate = startModeDelegate
        self.navigationController = .init(rootViewController: dailyListViewController)
        self.navigationController.tabBarItem = .init(tabBarSystemItem: .favorites, tag: 2)
    }
    
    func start() {
        dailyListViewModel.coordinator = self
    }
    
    func pushInfoCreateViewController(fetchRefreshDelegate: FetchRefreshDelegate) {
        let dailyInfoCreateCoordinator = DailyInfoCreateCoordinator(navigationController: self.navigationController,
                                                                    repository: repository,
                                                                    finishDelegate: self,
                                                                    fetchRefreshDelegate: fetchRefreshDelegate)
        dailyInfoCreateCoordinator.start()
        childCoordinators.append(dailyInfoCreateCoordinator)
    }
}
