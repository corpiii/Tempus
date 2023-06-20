//
//  DailyTimeDurationEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/06.
//

import Foundation

import RxRelay
import RxSwift

final class DailyTimeDurationEditViewModel {
    struct Input {
        let startTime: Observable<Date>
        let repeatCount: Observable<Double>
        
        let backButtonTapEvent: Observable<Void>
        let doneButtonTapEvent: Observable<Void>
        let completeEvent: Observable<Void>
    }
    
    struct Output {
        let isEditSuccess: PublishSubject<Bool>
    }
    
    private var startTime: Double?
    private var repeatCount: Int?
    
    private let editUseCase: DailyEditUseCase
    private var originModel: DailyModel
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    private weak var editReflectDelegate: EditReflectDelegate?
    
    private let completeButtonTapEvent: PublishSubject<DailyModel> = .init()
    
    weak var coordinator: DailyTimeDurationEditCoordinator?
    
    init(originModel: DailyModel,
         repository: DataManagerRepository,
         fetchRefreshDelegate: FetchRefreshDelegate?,
         editReflectDelegate: EditReflectDelegate?) {
        self.originModel = originModel
        self.editUseCase = .init(repository: repository)
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.editReflectDelegate = editReflectDelegate
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let editUseCaseInput = DailyEditUseCase.Input(modelEditEvent: self.completeButtonTapEvent)
        let editUseCaseOutput = editUseCase.transform(input: editUseCaseInput,
                                                      disposeBag: disposeBag)
        
        let output = Output(isEditSuccess: editUseCaseOutput.isEditSuccess)
        
        bindStartTime(input.startTime, disposeBag)
        bindRepeatCount(input.repeatCount, disposeBag)
        bindBackButtonTapEvent(input.backButtonTapEvent, disposeBag)
        bindDoneButtonTapEvent(input.doneButtonTapEvent, disposeBag)
        
        return output
    }
}

private extension DailyTimeDurationEditViewModel {
    func bindStartTime(_ startTime: Observable<Date>, _ disposeBag: DisposeBag) {
        startTime
            .subscribe(onNext: { [weak self] startTime in
                // self?.startTime = startTime
            }).disposed(by: disposeBag)
    }
    
    func bindRepeatCount(_ repeatCount: Observable<Double>, _ disposeBag: DisposeBag) {
        repeatCount
            .subscribe(onNext: { [weak self] repeatCount in
                self?.repeatCount = Int(repeatCount)
            }).disposed(by: disposeBag)
    }
    
    func bindDoneButtonTapEvent(_ doneButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        doneButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                
                if let startTime = self.startTime {
                    self.originModel.startTime = startTime
                }
                
                if let repeatCount = self.repeatCount {
                    self.originModel.repeatCount = repeatCount
                }
                
                self.completeButtonTapEvent.onNext(self.originModel)
            }).disposed(by: disposeBag)
    }
    
    func bindBackButtonTapEvent(_ backButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        backButtonTapEvent
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
    }
}
