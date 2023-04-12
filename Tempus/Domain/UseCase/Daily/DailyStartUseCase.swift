//
//  DailyStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/10.
//

import Foundation

import RxSwift

final class DailyStartUseCase {
    private var time: Time {
        didSet {
            timeObservable.onNext(time)
        }
    }
    private let timeObservable: PublishSubject<Time> = .init()
    private let originModel: DailyModel
    private var schedule: [Date] = []
    private var timer: Timer?
    
    init(originModel: DailyModel) {
        self.originModel = originModel
        self.time = Time(second: 0)
    }
    
    func isTimerOver() -> Bool {
        if time.totalSecond == 0 {
            return true
        } else {
            return false
        }
    }
}

extension DailyStartUseCase: ModeInfo {
    var type: ModeType {
        .daily
    }
    
    func fetchTimeObservable() -> PublishSubject<Time> {
        return timeObservable
    }
}

extension DailyStartUseCase: ModeController {
    func modeStart() {
        guard timer == nil else { return }
        
        /* Noti enroll */
        let interval = 1.0
        schedule = generateSchedule(originModel)
        
        let target = schedule[0].timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        time = Time(second: target - now)
        
        timer = Timer(timeInterval: interval, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            
            if self.time.totalSecond == 0 {
                let endDate = self.schedule.removeFirst()
                let addingOneDayDate = endDate.addingTimeInterval(24 * 60 * 60)
                
                self.schedule.append(addingOneDayDate)
                let now = Date().timeIntervalSince1970
                let target = self.schedule[0].timeIntervalSince1970
                
                self.time = Time(second: target - now)
            } else {
                self.time.flow(second: interval)
            }
        })
        
        RunLoop.current.add(timer!, forMode: .default)
        
    }
    
    func modeStop() {
        /* Noti remove */
        timer?.invalidate()
        timer = nil
    }
    
    private func generateSchedule(_ originModel: DailyModel) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        
        var startTime = calendar.startOfDay(for: now).addingTimeInterval(originModel.startTime)
        let repeatCount = originModel.repeatCount
        let focusTime = originModel.focusTime
        let breakTime = originModel.breakTime
        
        let oneIntervalSecond = focusTime + breakTime
        let oneDaySecond = 24.0 * 60.0 * 60.0
        
        var schedule: [Date] = []
        schedule.append(startTime)
        
        (1...repeatCount).forEach({ _ in
            schedule.append(startTime.addingTimeInterval(focusTime))
            schedule.append(startTime.addingTimeInterval(focusTime + breakTime))
            startTime = startTime.addingTimeInterval(oneIntervalSecond)
        })
        
        while schedule.first! < now {
            let lastDate = schedule.removeFirst()
            let newDate = lastDate.addingTimeInterval(oneDaySecond)
            schedule.append(newDate)
        }
        
        return schedule
    }
}
