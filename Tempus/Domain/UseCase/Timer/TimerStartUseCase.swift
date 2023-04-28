//
//  TimerStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/05.
//

import Foundation

import RxSwift

final class TimerStartUseCase: ModeStartUseCase {
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
    private var timer: Timer?
    private let originModel: TimerModel
    
    init(model: TimerModel) {
        self.originModel = model
        self.remainTime = Time(second: model.wasteTime)
        self.modeState = .focusTime
    }
    
    override func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(remainTime: timeObservable,
                            modeState: modeStateObservable)
        
        bindModeStartEvent(input.modeStartEvent, disposeBag: disposeBag)
        bindModeStopEvent(input.modeStopEvent, disposeBag: disposeBag)

        return output
    }
}

private extension TimerStartUseCase {
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

        let interval = 0.1
        self.modeState = .focusTime
        
        remainTime = Time(second: originModel.wasteTime)
        timer = Timer(timeInterval: interval, repeats: true, block: { [self] timer in
            if remainTime.totalSecond == 0 {
                /* Noti */
                remainTime = Time(second: originModel.wasteTime)
            } else {
                remainTime.flow(second: interval)
            }
        })
        
        RunLoop.current.add(timer!, forMode: .default)
    }
    
    func modeStop() {
        timer?.invalidate()
        timer = nil
    }
}
