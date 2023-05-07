//
//  TimerStartViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/07.
//

import Foundation

import RxSwift

final class TimerStartViewModel {
    struct Input {
        let modelWasteTime: Observable<Double>
        
        let startButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let isStartSuccess: PublishSubject<Bool> = .init()
    }
    
    private var wasteTime: Double?
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        bindModelWasteTime(input.modelWasteTime, disposeBag)
        bindStartButtonTapEvent(input.startButtonTapEvent, to: output.isStartSuccess, disposeBag)
        
        return output
    }
}

private extension TimerStartViewModel {
    func bindModelWasteTime(_ modelWasteTime: Observable<Double>, _ disposeBag: DisposeBag) {
        modelWasteTime
            .subscribe(onNext: { [weak self] wasteTime in
                self?.wasteTime = wasteTime
            }).disposed(by: disposeBag)
    }
    
    func bindStartButtonTapEvent(_ startButtonTapEvent: Observable<Void>,
                                 to isStartSuccess: PublishSubject<Bool>,
                                 _ disposeBag: DisposeBag) {
        startButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let wasteTime = self?.wasteTime else {
                    return isStartSuccess.onNext(false)
                }
                
                let originModel = TimerModel(id: UUID(), wasteTime: wasteTime)
                let startUseCase = TimerStartUseCase(originModel: originModel)
                
                isStartSuccess.onNext(true)
                // coordinator push with startUseCase
            }).disposed(by: disposeBag)
    }
    
}
