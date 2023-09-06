//
//  BlockListViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import RxSwift

protocol BlockListViewModel: AnyObject, FetchRefreshDelegate, ViewModel {
    var coordinator: BlockListViewCoordinator? { get set }
}
