//
//  DailyListViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/28.
//

import RxSwift

final class DailyListViewModel {
    struct Input {
        let addButtonEvent: Observable<Void>
        let modelDeleteEvent: Observable<DailyModel>
        let modelFetchEvent: PublishSubject<Void>
    }
    
    struct Output {
        let dailyModelArray: Observable<[DailyModel]>
        let isDeleteSuccess: Observable<Bool>
    }
}
