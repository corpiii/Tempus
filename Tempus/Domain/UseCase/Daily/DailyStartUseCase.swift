//
//  DailyStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/10.
//

import Foundation

import RxSwift

final class DailyStartUseCase {
    private var remainTime: Time {
        didSet {
            timeObservable.onNext(remainTime)
        }
    }
    private let timeObservable: PublishSubject<Time> = .init()
    private let disposeBag: DisposeBag = .init()
    private let originModel: DailyModel
    private var schedule: [Date] = []
    private var timer: Timer?
    
    init(originModel: DailyModel) {
        self.originModel = originModel
        self.remainTime = Time(second: 0)
    }
    
    private func modeStart() {
        guard timer == nil else { return }
        
        /* Noti enroll */
        let interval = 1.0
        schedule = generateSchedule(originModel)
        
        let target = schedule[0].timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        remainTime = Time(second: target - now)
        
        timer = Timer(timeInterval: interval, repeats: true, block: { [weak self] timer in
            guard let self else { return }
            
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
    
    private func modeStop() {
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

/// 버튼 이벤트를 inpput 받아서 modeStart, stop과 엮을 것.
/// 아웃풋으로 timeObservable 줄 것.
/// 그러면 ModeInfo와 ModeController가 필요한가? 그냥 하나로 합칠까
/// isp

extension DailyStartUseCase: ModeController {
    func bind(to input: Input) -> Output {
        let output = ClockStartUseCase.Output(remainTime: timeObservable)

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
