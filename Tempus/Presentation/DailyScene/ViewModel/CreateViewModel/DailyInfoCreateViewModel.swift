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
        let cancelButtonTapEvent: Observable<Void>
        let nextButtonTapEvent: Observable<Void>
        
        let modelTitle: Observable<String>
        let modelFocusTime: Observable<String>
        let modelBreakTime: Observable<String>
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
        
        bindNextButtonEvent(input.nextButtonTapEvent, to: output.isFillAllInfo, disposeBag)
        bindCancelButtonTapEvent(input.cancelButtonTapEvent, disposeBag)
        
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
    
    func bindModelFocusTime(_ modelFocusTime: Observable<String>, _ disposeBag: DisposeBag) {
        modelFocusTime
            .subscribe(onNext: { [weak self] focusTime in
                guard let self else { return }
                self.modelFocusTime = Double(focusTime)
            }).disposed(by: disposeBag)
    }
    
    func bindModelBreakTime(_ modelBreakTime: Observable<String>, _ disposeBag: DisposeBag) {
        modelBreakTime
            .subscribe(onNext: { [weak self] breakTime in
                guard let self else { return }
                self.modelBreakTime = Double(breakTime)
            }).disposed(by: disposeBag)
    }
    
    func bindNextButtonEvent(_ nextButtonTapEvent: Observable<Void>, to isFillAllInfo: PublishSubject<Bool>, _ disposeBag: DisposeBag) {
        nextButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      self.modelTitle != nil,
                      self.modelFocusTime != nil,
                      self.modelBreakTime != nil else {
                          return isFillAllInfo.onNext(false)
                }
                
                isFillAllInfo.onNext(true)
                // coordinator push
            }).disposed(by: disposeBag)
    }
    
    func bindCancelButtonTapEvent(_ cancelButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        cancelButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // coordinator finish createScene
            }).disposed(by: disposeBag)
    }

}
