//
//  DailyCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/30.
//

import RxRelay
import RxSwift

final class DailyInfoCreateViewModel {
    struct Input {
        let cancelButtonEvent: Observable<Void>
        let nextButtonEvent: Observable<Void>
        
        let modelTitle: Observable<String>
        let modelFocusTime: Observable<Double>
        let modelBreakTime: Observable<Double>
    }
    
    struct Output {
        let isFillAllInfo: PublishSubject<Bool> = .init()
    }
    
    private var modelTitle: String?
    private var modelFocusTime: Double?
    private var modelBreakTime: Double?
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        bindModelTitle(input.modelTitle, disposeBag)
        bindModelFocusTime(input.modelFocusTime, disposeBag)
        bindModelBreakTime(input.modelBreakTime, disposeBag)
        
        bindNextButtonEvent(input.nextButtonEvent, to: output.isFillAllInfo, disposeBag)
        bindCancelButtonTapEvent(input.cancelButtonEvent, disposeBag)
        
        return output
    }
}

private extension DailyInfoCreateViewModel {
    /* finish function by coordinator */
    // func finish() {}
    
    func bindModelTitle(_ modelTitle: Observable<String>, _ disposeBag: DisposeBag) {
        modelTitle
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                self.modelTitle = title
            }).disposed(by: disposeBag)
    }
    
    func bindModelFocusTime(_ modelFocusTime: Observable<Double>, _ disposeBag: DisposeBag) {
        modelFocusTime
            .subscribe(onNext: { [weak self] focusTime in
                guard let self = self else { return }
                self.modelFocusTime = focusTime
            }).disposed(by: disposeBag)
    }
    
    func bindModelBreakTime(_ modelBreakTime: Observable<Double>, _ disposeBag: DisposeBag) {
        modelBreakTime
            .subscribe(onNext: { [weak self] breakTime in
                guard let self = self else { return }
                self.modelBreakTime = breakTime
            }).disposed(by: disposeBag)
    }
    
    func bindNextButtonEvent(_ nextButtonTapEvent: Observable<Void>, to isFillAllInfo: PublishSubject<Bool>, _ disposeBag: DisposeBag) {
        nextButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if let modelTitle = self.modelTitle,
                   let modelFocusTime = self.modelFocusTime,
                   let modelBreakTime = self.modelBreakTime {
                    
                    // coordinator push with data
                } else {
                    isFillAllInfo.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func bindCancelButtonTapEvent(_ cancelButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        cancelButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // coordinator finish addScene
            }).disposed(by: disposeBag)
    }

}
