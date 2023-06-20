//
//  TimerViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/07.
//

import Foundation

import RxSwift

final class TimerViewModel {
    struct Input {
        let modelWasteTime: Observable<Date>
        
        let startButtonTapEvent: Observable<Void>
    }
    
    private var wasteTime: Double?
    
    func bind(input: Input, disposeBag: DisposeBag) {
        bindModelWasteTime(input.modelWasteTime, disposeBag)
        bindStartButtonTapEvent(input.startButtonTapEvent, disposeBag)
    }
}

private extension TimerViewModel {
    func bindModelWasteTime(_ modelWasteTime: Observable<Date>, _ disposeBag: DisposeBag) {
        modelWasteTime
            .subscribe(onNext: { [weak self] wasteTime in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: wasteTime)
                
                if let hour = components.hour,
                   let minute = components.minute {
                    let wasteTime = Double(hour * 60 * 60 + minute * 60)
                    self?.wasteTime = wasteTime
                }
            }).disposed(by: disposeBag)
    }
    
    func bindStartButtonTapEvent(_ startButtonTapEvent: Observable<Void>,
                                 _ disposeBag: DisposeBag) {
        startButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let wasteTime = self?.wasteTime else { return }
                
                let originModel = TimerModel(id: UUID(), wasteTime: wasteTime)
                let startUseCase = TimerStartUseCase(originModel: originModel)

                // coordinator push with startUseCase
            }).disposed(by: disposeBag)
    }
    
}
