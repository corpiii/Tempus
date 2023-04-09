//
//  BlockStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/07.
//

import Foundation

import RxSwift

final class BlockStartUseCase {
    private var time: Time {
        didSet {
            timeObservable.onNext(time)
        }
    }
    private let timeObservable: PublishSubject<Time> = .init()
    private let originModel: BlockModel
    private var schedule: [Date] = []
    
    init(originModel: BlockModel) {
        self.originModel = originModel
        self.time = Time(second: 0)
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
        self.schedule = generateSchedule(divideCount: originModel.divideCount)
    }
    
    func modeStop() {
        
    }
    
    func generateSchedule(divideCount: Double) -> [Date] {
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
        
        while schedule[1] < now {
            let lastDate = schedule.removeFirst()
            let newDate = lastDate.addingTimeInterval(oneDaySecond)
            schedule.append(newDate)
        }
        
        return schedule
    }
}
