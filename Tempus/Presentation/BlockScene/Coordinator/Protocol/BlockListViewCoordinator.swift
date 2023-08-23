//
//  BlockListViewCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/23.
//

protocol BlockListViewCoordinator: Coordinator, FinishDelegate, AnyObject {
    func pushCreateViewController(_ fetchRefreshDelegate: FetchRefreshDelegate)
    func pushDetailViewController(with model: BlockModel)
}
