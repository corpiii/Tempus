//
//  DailyTimeCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/02.
//

import Foundation

import RxSwift
import RxRelay

final class DailyTimeCreateViewModel {
    struct Input {
        let startTime: Observable<Double>
        let repeatCount: Observable<Int>
        
        let completeButtonTapEvent: Observable<Void>
        let backButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let isCreateSuccess: PublishRelay<Bool> = .init()
    }
    
    private let modelTitle: String
    private let focusTime: Double
    private let breakTime: Double
    private var startTime: Double?
    private var repeatCount: Int?
    
    private let modelCreateEvent: PublishSubject<DailyModel> = .init()
    
    private let createUseCase: DailyCreateUseCase
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    
    init(modelTitle: String,
         focusTime: Double,
         breakTime: Double,
         repository: DataManagerRepository,
         fetchRefreshDelgate: FetchRefreshDelegate) {
        self.modelTitle = modelTitle
        self.focusTime = focusTime
        self.breakTime = breakTime
        
        self.createUseCase = .init(repository: repository)
        self.fetchRefreshDelegate = fetchRefreshDelgate
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.startTime
            .subscribe(onNext: { [weak self] startTime in
                guard let self = self else { return }
                self.startTime = startTime
            }).disposed(by: disposeBag)
        
        input.repeatCount
            .subscribe(onNext: { [weak self] repeatCount in
                guard let self = self else { return }
                self.repeatCount = repeatCount
            }).disposed(by: disposeBag)
        
        input.completeButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                guard let startTime = self.startTime,
                      let repeatCount = self.repeatCount else { return }
                
                let model = DailyModel(id: UUID(),
                                       title: self.modelTitle,
                                       startTime: startTime,
                                       repeatCount: repeatCount,
                                       focusTime: self.focusTime,
                                       breakTime: self.breakTime)
                
                self.modelCreateEvent.onNext(model)
            }).disposed(by: disposeBag)
        
        return output
    }
    
    /* finish function by coordinator */
    // func finish() {}
}
