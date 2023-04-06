//
//  TimerStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/05.
//

import Foundation

import RxSwift

final class TimerStartUseCase {
    private var time: Time
    private let timeObservable: BehaviorSubject<Time>
    private var timer: Timer?
    
    init(model: TimerModel) {
        self.time = Time(second: model.wasteTime)
        self.timeObservable = BehaviorSubject(value: self.time)
    }
    
    private func flowSecond(second: Double) {
        time.flow(second: second)
        timeObservable.onNext(time)
    }
    
    func isTimerOver() -> Bool {
        if time.totalSecond == 0 {
            return true
        } else {
            return false
        }
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
        let interval = 0.1
        timer = Timer(timeInterval: interval, repeats: true, block: { timer in
            self.flowSecond(second: interval)
        })
        
        if timer != nil {
            RunLoop.current.add(timer!, forMode: .default)
        }
    }
    
    func modeStop() {
        timer?.invalidate()
        timer = nil
    }
}
