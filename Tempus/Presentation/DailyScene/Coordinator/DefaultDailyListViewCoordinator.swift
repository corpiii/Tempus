//
//  DefaultDailyListViewCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/04.
//

import UIKit

final class DefaultDailyListViewCoordinator: DailyListViewCoordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .dailyList }
    
    let navigationController: UINavigationController
    private let repository: DataManagerRepository
    
    private weak var startModeDelegate: StartModeDelegate?
    
    private let dailyListViewModel: DefaultDailyListViewModel
    private let dailyListViewController: DailyListViewController
    
    init(repository: DataManagerRepository, startModeDelegate: StartModeDelegate) {
        let tabBarImage = UIImage(systemName: "calendar")
        let tabBarItem = UITabBarItem(title: nil, image: tabBarImage, selectedImage: nil)
        
        self.repository = repository
        self.dailyListViewModel = .init(repository: self.repository)
        self.dailyListViewController = .init(viewModel: self.dailyListViewModel)
        self.startModeDelegate = startModeDelegate
        self.navigationController = .init(rootViewController: dailyListViewController)
        self.navigationController.tabBarItem = tabBarItem
    }
    
    func start() {
        dailyListViewModel.coordinator = self
    }
    
    func pushInfoCreateViewController(fetchRefreshDelegate: FetchRefreshDelegate) {
        let dailyInfoCreateCoordinator = DefaultDailyInfoCreateCoordinator(navigationController: self.navigationController,
                                                                    repository: self.repository,
                                                                    finishDelegate: self,
                                                                    fetchRefreshDelegate: fetchRefreshDelegate,
                                                                    startModeDelegate: self.startModeDelegate)
        dailyInfoCreateCoordinator.start()
        childCoordinators.append(dailyInfoCreateCoordinator)
    }
    
    func pushDetailViewController(originModel: DailyModel, fetchRefreshDelegate: FetchRefreshDelegate) {
        let dailyDetailCoordinator = DefaultDailyDetailCoordinator(navigationController: self.navigationController,
                                                            repository: self.repository,
                                                            originModel: originModel,
                                                            finishDelegate: self,
                                                            fetchRefreshDelegate: fetchRefreshDelegate,
                                                            startModeDelegate: self.startModeDelegate)
        dailyDetailCoordinator.start()
        childCoordinators.append(dailyDetailCoordinator)
    }
}
