//
//  TimerStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/05.
//

import Foundation

import RxSwift
import UserNotifications

final class TimerStartUseCase: ModeStartUseCase {
    private let notificationIdentifier: String = "TimerNotification"
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
    private var timer: Timer?
    private let originModel: TimerModel
    
    init(originModel: TimerModel) {
        self.originModel = originModel
        self.remainTime = Time(second: originModel.wasteTime)
        self.modeState = .focusTime
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(remainTime: timeObservable,
                            modeState: modeStateObservable,
                            entireRunningTime: entireRunningTime)
        
        bindModeStartEvent(input.modeStartEvent, disposeBag: disposeBag)
        bindModeStopEvent(input.modeStopEvent, disposeBag: disposeBag)

        NotificationCenter.default.addObserver(self, selector: #selector(adjustDate), name: NSNotification.Name("inOutDateNotification"), object: nil)
        
        return output
    }
}

private extension TimerStartUseCase {
    @objc func adjustDate(_ sender: Notification) {
        timerStart()
        
        if let object = sender.object as? Double {
            let date = Date(timeIntervalSince1970: object)
            let flowSecond = Date().timeIntervalSince(date)
            let interval = flowSecond.truncatingRemainder(dividingBy: originModel.wasteTime)
            remainTime.flow(second: interval)
        }
    }
    
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
        removeNotification()
        enrollNotification(originModel.wasteTime)
        timerStart()
    }
    
    func enrollNotification(_ wasteTime: Double) {
        let content = UNMutableNotificationContent()
        content.title = "알림"
        content.body = "Timer"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: wasteTime, repeats: true)
        let request = UNNotificationRequest(identifier: self.notificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func timerStart() {
        guard timer == nil else { return }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(originModel) {
            UserDefaults.standard.set(true, forKey: "isModeStarted")
            UserDefaults.standard.set(encoded, forKey: "model")
        }
        
        let interval = 0.1
        self.modeState = .focusTime
        entireRunningTime.onNext(originModel.wasteTime)
        remainTime = Time(second: originModel.wasteTime)
        timer = Timer(timeInterval: interval, repeats: true, block: { [weak self] timer in
            guard let self else { return }
            self.remainTime.flow(second: interval)
            
            if self.remainTime.totalSecond <= 0 {
                self.remainTime = Time(second: self.originModel.wasteTime)
            }
        })
        
        RunLoop.current.add(timer!, forMode: .default)
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
}
