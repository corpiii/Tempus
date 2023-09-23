//
//  DefaultTimerViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/07.
//

import Foundation

import RxSwift

final class DefaultTimerViewModel: TimerViewModel {
    struct Input {
        let modelWasteTime: Observable<Date>
        
        let startButtonTapEvent: Observable<Void>
    }
    
    var wasteTime: Double?
    weak var coordinator: TimerCoordinator?
    
    func bind<InputType>(input: InputType, disposeBag: RxSwift.DisposeBag) {
        guard let input = input as? Input else {
            return
        }
        
        bindModelWasteTime(input.modelWasteTime, disposeBag)
        bindStartButtonTapEvent(input.startButtonTapEvent, disposeBag)
    }
}

private extension DefaultTimerViewModel {
    func bindModelWasteTime(_ modelWasteTime: Observable<Date>, _ disposeBag: DisposeBag) {
        modelWasteTime
            .subscribe(onNext: { [weak self] wasteTime in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: wasteTime)
                
                if let hour = components.hour,
                   let minute = components.minute {
                    
                    let wasteTime = Double(hour * 60 * 60 + minute * 60)
                    if wasteTime == 0 {
                        self?.wasteTime = 1.0 * 60
                    } else {
                        self?.wasteTime = wasteTime
                    }
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

                self?.coordinator?.finish(startUseCase)
            }).disposed(by: disposeBag)
    }
    
}
