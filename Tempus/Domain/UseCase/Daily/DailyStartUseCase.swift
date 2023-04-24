//
//  DailyStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/10.
//

import Foundation

import RxSwift

final class DailyStartUseCase: ModeStartUseCase {
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
    private let disposeBag: DisposeBag = .init()
    private let originModel: DailyModel
    private var timeSchedule: [Date] = []
    private var stateSchedule: [ModeState] = []
    private var timer: Timer?
    
    init(originModel: DailyModel) {
        self.originModel = originModel
        self.remainTime = Time(second: 0)
        self.modeState = .waitingTime
    }
    
    func transform(to input: Input) -> Output {
        let output = Output(remainTime: timeObservable,
                            modeState: modeStateObservable)

        input.modeStartEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.modeStart()
            }).disposed(by: disposeBag)

        input.modeStopEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.modeStop()
            }).disposed(by: disposeBag)

        return output
    }
}

private extension DailyStartUseCase {
    func modeStart() {
        guard timer == nil else { return }
        
        /* Noti enroll */
        let interval = 1.0
        let schedule = generateSchedule(originModel)
        
        timeSchedule = schedule.timeSchedule
        stateSchedule = schedule.stateSchedule
        
        let target = timeSchedule[0].timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        
        remainTime = Time(second: target - now)
        modeState = stateSchedule[0]
        
        timer = Timer(timeInterval: interval, repeats: true, block: { [weak self] timer in
            guard let self else { return }
            
            if self.remainTime.totalSecond == 0 {
                let endDate = self.timeSchedule.removeFirst()
                let endState = self.stateSchedule.removeFirst()
                
                let addingOneDayDate = endDate.addingTimeInterval(24 * 60 * 60)
                
                let now = Date().timeIntervalSince1970
                let target = self.timeSchedule[0].timeIntervalSince1970
                
                self.timeSchedule.append(addingOneDayDate)
                self.stateSchedule.append(endState)
                
                self.remainTime = Time(second: target - now)
                self.modeState = endState
            } else {
                self.remainTime.flow(second: interval)
            }
        })
        
        RunLoop.current.add(timer!, forMode: .default)
    }
    
    func modeStop() {
        /* Noti remove */
        timer?.invalidate()
        timer = nil
    }
    
    func generateSchedule(_ originModel: DailyModel) -> (timeSchedule: [Date], stateSchedule: [ModeState]) {
        let calendar = Calendar.current
        let now = Date()
        
        var startTime = calendar.startOfDay(for: now).addingTimeInterval(originModel.startTime)
        let repeatCount = originModel.repeatCount
        let focusTime = originModel.focusTime
        let breakTime = originModel.breakTime
        
        let oneIntervalSecond = focusTime + breakTime
        let oneDaySecond = 24.0 * 60.0 * 60.0
        
        var schedule: [Date] = []
        var state: [ModeState] = []
        
        schedule.append(startTime)
        state.append(.focusTime)
        
        (1...repeatCount).forEach({ _ in
            schedule.append(startTime.addingTimeInterval(focusTime))
            state.append(.breakTime)
            schedule.append(startTime.addingTimeInterval(focusTime + breakTime))
            state.append(.focusTime)
            startTime = startTime.addingTimeInterval(oneIntervalSecond)
        })
        
        state.removeLast()
        state.append(.waitingTime)
        
        while schedule.first! < now {
            let lastDate = schedule.removeFirst()
            let newDate = lastDate.addingTimeInterval(oneDaySecond)
            schedule.append(newDate)
        }
        
        return (schedule, state)
    }
}
