//
//  BlockStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/07.
//

import Foundation

import RxSwift
import UIKit

/// Start Block used by BlockModel
final class BlockStartUseCase: ModeStartUseCase {
    private var remainTime: Time {
        didSet {
            timeObservable.onNext(remainTime)
        }
    }
    private var modeState: ModeState {
        didSet {
            modeStateObservable.onNext(modeState)
        }
    }
    
    private let timeObservable: PublishSubject<Time> = .init()
    private let modeStateObservable: PublishSubject<ModeState> = .init()
    private let entireRunningTime: PublishSubject<Double> = .init()
    private let disposeBag: DisposeBag = .init()
    private let originModel: BlockModel
    private var schedule: [Date] = []
    private var timer: Timer?
    
    init(originModel: BlockModel) {
        self.originModel = originModel
        self.remainTime = Time(second: 0)
        self.modeState = .focusTime
    }
    
    override func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(remainTime: timeObservable,
                            modeState: modeStateObservable,
                            entireRunningTime: entireRunningTime)
        
        bindModeStartEvent(input.modeStartEvent, disposeBag: disposeBag)
        bindModeStopEvent(input.modeStopEvent, disposeBag: disposeBag)

        return output
    }
}

private extension BlockStartUseCase {
    func bindModeStartEvent(_ modeStartEvent: Observable<Void>, disposeBag: DisposeBag) {
        modeStartEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.modeStart()
            }).disposed(by: disposeBag)
    }
    
    func bindModeStopEvent(_ modeStopEvent: Observable<Void>, disposeBag: DisposeBag) {
        modeStopEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.modeStop()
            }).disposed(by: disposeBag)
    }
    
    func modeStart() {
        guard timer == nil else { return }
        
        /* Noti enroll */
        
        let interval = 1.0
        self.schedule = generateSchedule(divideCount: originModel.divideCount)
        self.modeState = .focusTime
        
        let target = schedule[0].timeIntervalSince1970
        entireRunningTime.onNext(Double(24 / originModel.divideCount) * 60 * 60)
        let now = Date().timeIntervalSince1970
        remainTime = Time(second: target - now)
                
        timer = Timer(timeInterval: interval, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            
            if self.remainTime.totalSecond == 0 {
                let endDate = self.schedule.removeFirst()
                let addingOneDayDate = endDate.addingTimeInterval(24 * 60 * 60)
                
                self.schedule.append(addingOneDayDate)
                let now = Date().timeIntervalSince1970
                let target = self.schedule[0].timeIntervalSince1970
                
                self.remainTime = Time(second: target - now)
            } else {
                self.remainTime.flow(second: interval)
            }
        })
        
        RunLoop.current.add(timer!, forMode: .default)
    }
    
    func modeStop() {
        timer?.invalidate()
        timer = nil
    }
    
    func generateSchedule(divideCount: Int) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        let interval = Double(24 / divideCount)
        let oneDaySecond = 24.0 * 60.0 * 60.0
        let oneHourSecond = 60.0 * 60.0
        
        var schedule: [Date] = []
        var date = calendar.startOfDay(for: now)
        let lastDate = date.addingTimeInterval(oneDaySecond)
        
        while date < lastDate {
            schedule.append(date)
            date = date.addingTimeInterval(interval * oneHourSecond)
        }
        
        while schedule.first! < now {
            let lastDate = schedule.removeFirst()
            let newDate = lastDate.addingTimeInterval(oneDaySecond)
            schedule.append(newDate)
        }
        
        return schedule
    }
}
