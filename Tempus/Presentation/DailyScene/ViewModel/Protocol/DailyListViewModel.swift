//
//  DailyListViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import RxSwift

protocol DailyListViewModel: AnyObject, ViewModel, FetchRefreshDelegate {
    var coordinator: DailyListViewCoordinator? { get set }
}
