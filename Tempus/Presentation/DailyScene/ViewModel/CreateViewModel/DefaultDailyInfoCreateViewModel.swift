//
//  DailyCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/30.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultDailyInfoCreateViewModel: DailyInfoCreateViewModel {
    struct Input {
        let cancelButtonTapEvent: Observable<Void>
        let nextButtonTapEvent: Observable<Void>
        
        let modelTitle: Observable<String>
        let modelFocusTime: Observable<Date>
        let modelBreakTime: Observable<Date>
    }
    
    struct Output {
        let isFillAllInfo: PublishSubject<Bool> = .init()
    }
    
    private var modelTitle: String?
    private var modelFocusTime: Double?
    private var modelBreakTime: Double?
    weak var coordinator: DailyInfoCreateCoordinator?
    
    func transform<InputType, OutputType>(input: InputType, disposeBag: RxSwift.DisposeBag) -> OutputType? {
        guard let input = input as? Input else {
            return nil
        }
        
        let output = Output()
        
        bindModelTitle(input.modelTitle, disposeBag)
        bindModelFocusTime(input.modelFocusTime, disposeBag)
        bindModelBreakTime(input.modelBreakTime, disposeBag)
        
        bindNextButtonEvent(input.nextButtonTapEvent, to: output.isFillAllInfo, disposeBag)
        bindCancelButtonTapEvent(input.cancelButtonTapEvent, disposeBag)
        
        return output as? OutputType
    }
}

private extension DefaultDailyInfoCreateViewModel {
    func bindModelTitle(_ modelTitle: Observable<String>, _ disposeBag: DisposeBag) {
        modelTitle
            .subscribe(onNext: { [weak self] title in
                self?.modelTitle = title
            }).disposed(by: disposeBag)
    }
    
    func bindModelFocusTime(_ modelFocusTime: Observable<Date>, _ disposeBag: DisposeBag) {
        modelFocusTime
            .subscribe(onNext: { [weak self] focusTime in
                let calendar = Calendar.init(identifier: .gregorian)
                let date = calendar.dateComponents([.hour, .minute], from: focusTime)
                
                if let hour = date.hour, let minute = date.minute {
                    let secondTime = Double(hour) * 60 * 60 + Double(minute) * 60
                    
                    if secondTime == 0 {
                        self?.modelFocusTime = 1.0 * 60
                    } else {
                        self?.modelFocusTime = secondTime
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func bindModelBreakTime(_ modelBreakTime: Observable<Date>, _ disposeBag: DisposeBag) {
        modelBreakTime
            .subscribe(onNext: { [weak self] breakTime in
                let calendar = Calendar.init(identifier: .gregorian)
                let date = calendar.dateComponents([.hour, .minute], from: breakTime)
                
                if let hour = date.hour, let minute = date.minute {
                    let secondTime = Double(hour) * 60 * 60 + Double(minute) * 60
                    
                    if secondTime == 0 {
                        self?.modelBreakTime = 1.0 * 60
                    } else {
                        self?.modelBreakTime = secondTime
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func bindNextButtonEvent(_ nextButtonTapEvent: Observable<Void>, to isFillAllInfo: PublishSubject<Bool>, _ disposeBag: DisposeBag) {
        nextButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let modelTitle = self?.modelTitle,
                      let modelFocusTime = self?.modelFocusTime,
                      let modelBreakTime = self?.modelBreakTime,
                      modelTitle.isEmpty == false else {
                          return isFillAllInfo.onNext(false)
                }
                
                self?.coordinator?.pushTimeDurationCreateViewController(modelTitle: modelTitle,
                                                                        focusTime: modelFocusTime,
                                                                        breakTime: modelBreakTime)
                return isFillAllInfo.onNext(true)
            }).disposed(by: disposeBag)
    }
    
    func bindCancelButtonTapEvent(_ cancelButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        cancelButtonTapEvent
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            }).disposed(by: disposeBag)
    }

}
