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
                                                                    repository: self.repository,
                                                                    finishDelegate: self,
                                                                    fetchRefreshDelegate: fetchRefreshDelegate,
                                                                    startModeDelegate: self.startModeDelegate)
        dailyInfoCreateCoordinator.start()
        childCoordinators.append(dailyInfoCreateCoordinator)
    }
    
    func pushDetailViewController(originModel: DailyModel, fetchRefreshDelegate: FetchRefreshDelegate) {
        let dailyDetailCoordinator = DailyDetailCoordinator(navigationController: self.navigationController,
                                                            repository: self.repository,
                                                            originModel: originModel,
                                                            finishDelegate: self,
                                                            fetchRefreshDelegate: fetchRefreshDelegate,
                                                            startModeDelegate: self.startModeDelegate)
        dailyDetailCoordinator.start()
        childCoordinators.append(dailyDetailCoordinator)
    }
}
