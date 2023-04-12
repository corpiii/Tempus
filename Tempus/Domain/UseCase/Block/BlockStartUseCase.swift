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
final class BlockStartUseCase {
    private var time: Time {
        didSet {
            timeObservable.onNext(time)
        }
    }
    private let timeObservable: PublishSubject<Time> = .init()
    private let originModel: BlockModel
    private var schedule: [Date] = []
    private var timer: Timer?
    
    init(originModel: BlockModel) {
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

extension BlockStartUseCase: ModeInfo {
    var type: ModeType {
        return .block
    }
    
    func fetchTimeObservable() -> PublishSubject<Time> {
        return timeObservable
    }
}

extension BlockStartUseCase: ModeController {
    func modeStart() {
        guard timer == nil else { return }
        
        /* Noti enroll */
        
        let interval = 1.0
        self.schedule = generateSchedule(divideCount: originModel.divideCount)
        
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
        timer?.invalidate()
        timer = nil
    }
    
    private func generateSchedule(divideCount: Double) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        let interval = 24 / divideCount
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
