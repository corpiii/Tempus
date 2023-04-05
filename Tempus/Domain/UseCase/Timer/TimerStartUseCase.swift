//
//  TimerStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/05.
//

import Foundation

import RxSwift

class TimerStartUseCase {
    private var time: Time
    private let timeObservable: BehaviorSubject<Time>
    
    init(model: TimerModel) {
        self.time = Time(second: model.wasteTime)
        self.timeObservable = BehaviorSubject(value: self.time)
    }
    
    private func flowOneSecond() {
        time.flowOneSecond()
        timeObservable.onNext(time)
    }
}

extension TimerStartUseCase: ModeInfo {
    var type: ModeType {
        return .timer
    }
    
    func fetchTimeObservable() -> BehaviorSubject<Time> {
        return timeObservable
    }
}

extension TimerStartUseCase: ModeController {
    func modeStart() {
        
    }
    
    func modeStop() {
        
    }
}
