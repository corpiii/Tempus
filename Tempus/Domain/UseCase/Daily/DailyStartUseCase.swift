//
//  DailyStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/10.
//

import Foundation

import RxSwift
import UserNotifications

final class DailyStartUseCase: ModeStartUseCase {
    private let notificationIdentifier: String = "DailyNotification"
    private var remainTime: Time {
        didSet {
            remainTimeSubject.onNext(remainTime)
        }
    }
    private var modeState: ModeState {
        didSet {
            modeStateObservable.onNext(modeState)
        }
    }
    
    private let remainTimeSubject: PublishSubject<Time> = .init()
    private let modeStateObservable: PublishSubject<ModeState> = .init()
    private let entireRunningTime: PublishSubject<Double> = .init()
    private let disposeBag: DisposeBag = .init()
    private let originModel: DailyModel
    private var timeSchedule: [Date] = []
    private var stateSchedule: [ModeState] = []
    private var timer: Timer?
    
    init(originModel: DailyModel) {
        self.originModel = originModel
        self.remainTime = Time(second: 0)
        self.modeState = .waitingTime
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(remainTime: remainTimeSubject,
                            modeState: modeStateObservable,
                            entireRunningTime: entireRunningTime)
        
        bindModeStartEvent(input.modeStartEvent, disposeBag: disposeBag)
        bindModeStopEvent(input.modeStopEvent, disposeBag: disposeBag)

        return output
    }
}

private extension DailyStartUseCase {
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
        
        removeNotification()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(originModel) {
            UserDefaults.standard.set(true, forKey: "isModeStarted")
            UserDefaults.standard.set(encoded, forKey: "model")
        }
        
        let interval = 0.1
        let schedule = generateSchedule(originModel)
        
        timeSchedule = schedule.timeSchedule
        stateSchedule = schedule.stateSchedule
        
        let target = timeSchedule[0].timeIntervalSince(Date())
        
        remainTime = Time(second: target)
        modeState = stateSchedule[0]
        
        print(timeSchedule)
        print(stateSchedule)
        
        switch modeState {
            case .focusTime: self.entireRunningTime.onNext(self.originModel.focusTime)
            case .breakTime: self.entireRunningTime.onNext(self.originModel.breakTime)
            case .waitingTime: self.entireRunningTime.onNext(.zero)
        }
        
        timer = Timer(timeInterval: interval, repeats: true, block: { [weak self] timer in
            guard let self else { return }
            self.remainTime.flow(second: interval)
            
            if self.remainTime.totalSecond <= 0 {
                let endDate = self.timeSchedule.removeFirst()
                let endState = self.stateSchedule.removeFirst()
                
                let addingOneDayDate = endDate.addingTimeInterval(24 * 60 * 60)
                
                let target = self.timeSchedule[0].timeIntervalSince(Date())
                let nowState = self.stateSchedule[0]
                
                switch nowState {
                    case .focusTime: self.entireRunningTime.onNext(self.originModel.focusTime)
                    case .breakTime: self.entireRunningTime.onNext(self.originModel.breakTime)
                    case .waitingTime: self.entireRunningTime.onNext(0)
                }
                
                self.timeSchedule.append(addingOneDayDate)
                self.stateSchedule.append(endState)
                
                self.remainTime = Time(second: target)
                self.modeState = endState
            }
        })
        
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func modeStop() {
        removeNotification()
        UserDefaults.standard.set(false, forKey: "isModeStarted")
        timer?.invalidate()
        timer = nil
    }
    
    func removeNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func generateSchedule(_ originModel: DailyModel) -> (timeSchedule: [Date], stateSchedule: [ModeState]) {
        let calendar = Calendar.current
        let now = Date()
        
        var startTime = calendar.startOfDay(for: now).addingTimeInterval(originModel.startTime)
        let repeatCount = originModel.repeatCount
        let modelFocusTime = originModel.focusTime
        let modelBreakTime = originModel.breakTime
        
        let oneIntervalSecond = modelFocusTime + modelBreakTime
        let oneDaySecond = 24.0 * 60.0 * 60.0
        
        var schedule: [Date] = []
        var state: [ModeState] = []
        
        schedule.append(startTime)
        state.append(.waitingTime)
        enrollNotification(startTime)
        
        (1...repeatCount).forEach({ _ in
            let focusTime = startTime.addingTimeInterval(modelFocusTime)
            schedule.append(focusTime)
            state.append(.focusTime)
            enrollNotification(focusTime)

            let breakTime = startTime.addingTimeInterval(modelFocusTime + modelBreakTime)
            schedule.append(breakTime)
            state.append(.breakTime)
            enrollNotification(breakTime)
            
            startTime = startTime.addingTimeInterval(oneIntervalSecond)
        })
        
        while schedule.first! < now {
            let lastDate = schedule.removeFirst()
            let newDate = lastDate.addingTimeInterval(oneDaySecond)
            schedule.append(newDate)
            
            let lastState = state.removeFirst()
            state.append(lastState)
        }
        
        return (schedule, state)
    }
    
    func enrollNotification(_ date: Date) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        let content = UNMutableNotificationContent()
        content.title = "알림"
        content.body = "Daily Timer"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName("ringTune.m4a"))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().description, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
