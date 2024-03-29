//
//  DefaultDailyTimeDurationCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/02.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultDailyTimeDurationCreateViewModel: DailyTimeDurationCreateViewModel {
    struct Input {
        let startTime: Observable<Date>
        let repeatCount: Observable<Double>
        
        let backButtonTapEvent: Observable<Void>
        let completeButtonTapEvent: Observable<Void>
        let startEvent: Observable<CompleteAlert>
    }
    
    struct Output {
        let isCreateSuccess: PublishRelay<Bool> = .init()
    }
    
    private let modelTitle: String
    private let focusTime: Double
    private let breakTime: Double
    private var startTime: Double?
    private var repeatCount: Int?
    private var originModel: DailyModel?
    
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
    
    func transform<InputType, OutputType>(input: InputType, disposeBag: DisposeBag) -> OutputType? {
        guard let input = input as? Input else {
            return nil
        }
        
        let output = Output()
        
        let createUseCaseInput = DailyCreateUseCase.Input(modelCreate: modelCreateEvent)
        let createUseCaseOutput = createUseCase.transform(input: createUseCaseInput,
                                                          disposeBag: disposeBag)
        
        bindCreateSuccess(createUseCaseOutput.isCreateSuccess, to: output.isCreateSuccess, disposeBag)
        bindStartTime(input.startTime, disposeBag)
        bindRepeatCount(input.repeatCount, disposeBag)
        bindBackButtonTapEvent(input.backButtonTapEvent, disposeBag)
        bindCompleteButtonTapEvent(input.completeButtonTapEvent, disposeBag)
        bindStartEvent(input.startEvent, disposeBag)
        
        return output as? OutputType
    }
}

private extension DefaultDailyTimeDurationCreateViewModel {
    func bindStartTime(_ startTime: Observable<Date>, _ disposeBag: DisposeBag) {
        startTime
            .subscribe(onNext: { [weak self] startTime in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: startTime)
                
                if let hour = components.hour,
                   let minute = components.minute {
                    let startTime = Double(hour * 60 * 60 + minute * 60)
                    
                    if startTime == 0 {
                        self?.startTime = 1.0 * 60
                    } else {                    
                        self?.startTime = startTime
                    }
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
    
    func bindCompleteButtonTapEvent(_ completeEvent: Observable<Void>,
                           _ disposeBag: DisposeBag) {
        completeEvent
            .subscribe(onNext: { [weak self] in
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
                self.originModel = model
                
            }).disposed(by: disposeBag)
    }
    
    func bindStartEvent(_ startEvent: Observable<CompleteAlert>, _ disposeBag: DisposeBag) {
        startEvent.subscribe(onNext: { [weak self] completeAlert in
            guard let originModel = self?.originModel else { return }
            
            switch completeAlert {
            case .completeWithStart:
                let startUseCase = DailyStartUseCase(originModel: originModel)
                self?.coordinator?.completeFinish(with: startUseCase)
                break
            case .completeWithoutStart:
                self?.coordinator?.completeFinish(with: nil)
                break
            }
        }).disposed(by: disposeBag)
    }
    
    func bindCreateSuccess(_ createSuccessEvent: Observable<Bool>,
                           to isCreateSuccess: PublishRelay<Bool>,
                           _ disposeBag: DisposeBag) {
        createSuccessEvent
            .subscribe(onNext: { [weak self] isSuccess in
                if isSuccess {
                    self?.fetchRefreshDelegate?.refresh()
                }
                
                isCreateSuccess.accept(isSuccess)
            }).disposed(by: disposeBag)
    }
}
