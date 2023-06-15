//
//  DailyTimeDurationCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/02.
//

import Foundation

import RxRelay
import RxSwift

final class DailyTimeDurationCreateViewModel {
    struct Input {
        let startTime: Observable<Date>
        let repeatCount: Observable<Double>
        
        let backButtonTapEvent: Observable<Void>
        let completeButtonTapEvent: Observable<CompleteAlert>
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
    weak var coordinator: DailyTimeDurationCreateCoordinator?
    
    init(modelTitle: String,
         focusTime: Double,
         breakTime: Double,
         repository: DataManagerRepository,
         fetchRefreshDelgate: FetchRefreshDelegate?) {
        self.modelTitle = modelTitle
        self.focusTime = focusTime
        self.breakTime = breakTime
        
        self.createUseCase = .init(repository: repository)
        self.fetchRefreshDelegate = fetchRefreshDelgate
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let createUseCaseInput = DailyCreateUseCase.Input(modelCreate: modelCreateEvent)
        let createUseCaseOutput = createUseCase.transform(input: createUseCaseInput,
                                                          disposeBag: disposeBag)
        
        bindStartTime(input.startTime, disposeBag)
        bindRepeatCount(input.repeatCount, disposeBag)
        bindBackButtonTapEvent(input.backButtonTapEvent, disposeBag)
        bindCompleteButtonTapEvent(input.completeButtonTapEvent, disposeBag)
        bindCreateSuccess(createUseCaseOutput.isCreateSuccess, to: output.isCreateSuccess, disposeBag)
        
        return output
    }
}

private extension DailyTimeDurationCreateViewModel {
    func bindStartTime(_ startTime: Observable<Date>, _ disposeBag: DisposeBag) {
        startTime
            .subscribe(onNext: { [weak self] startTime in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: startTime)
                
                if let hour = components.hour,
                   let minute = components.minute {
                    let startTime = Double(hour * 60 * 60 + minute * 60)
                    self?.startTime = startTime
                }
            }).disposed(by: disposeBag)
    }
    
    func bindRepeatCount(_ repeatCount: Observable<Double>, _ disposeBag: DisposeBag) {
        repeatCount
            .subscribe(onNext: { [weak self] repeatCount in
                self?.repeatCount = Int(repeatCount)
            }).disposed(by: disposeBag)
    }
    
    func bindBackButtonTapEvent(_ backButtonTapEvent: Observable<Void>,
                                _ disposeBag: DisposeBag) {
        backButtonTapEvent
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            }).disposed(by: disposeBag)
    }
    
    func bindCompleteButtonTapEvent(_ completeEvent: Observable<CompleteAlert>,
                           _ disposeBag: DisposeBag) {
        completeEvent
            .subscribe(onNext: { [weak self] completeAlert in
                guard let self = self,
                      let startTime = self.startTime,
                      let repeatCount = self.repeatCount else { return }
                
                let model = DailyModel(id: UUID(),
                                       title: self.modelTitle,
                                       startTime: startTime,
                                       repeatCount: repeatCount,
                                       focusTime: self.focusTime,
                                       breakTime: self.breakTime)
                
                self.modelCreateEvent.onNext(model)
                
                switch completeAlert {
                case .completeWithStart:
                    let startUseCase = DailyStartUseCase(originModel: model)
                    self.coordinator?.completeFinish(with: startUseCase)
                    break
                case .completeWithoutStart:
                    self.coordinator?.completeFinish()
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    func bindCreateSuccess(_ createSuccessEvent: Observable<Bool>,
                           to isCreateSuccess: PublishRelay<Bool>,
                           _ disposeBag: DisposeBag) {
        createSuccessEvent
            .subscribe(onNext: { [weak self] isSuccess in
                guard let self = self else { return }
                if isSuccess {
                    self.fetchRefreshDelegate?.refresh()
                }
                
                isCreateSuccess.accept(isSuccess)
            }).disposed(by: disposeBag)
    }
}
