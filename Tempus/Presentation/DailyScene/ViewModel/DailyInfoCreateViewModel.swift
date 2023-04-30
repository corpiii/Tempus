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
        
        input.modelTitle
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                self.modelTitle = title
            }).disposed(by: disposeBag)
        
        input.modelFocusTime
            .subscribe(onNext: { [weak self] focusTime in
                guard let self = self else { return }
                self.modelFocusTime = focusTime
            }).disposed(by: disposeBag)
        
        input.modelBreakTime
            .subscribe(onNext: { [weak self] breakTime in
                guard let self = self else { return }
                self.modelBreakTime = breakTime
            }).disposed(by: disposeBag)
        
        input.nextButtonEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if let modelTitle = self.modelTitle,
                   let modelFocusTime = self.modelFocusTime,
                   let modelBreakTime = self.modelBreakTime {
                    
                    // coordinaotr push with data
                } else {
                    output.isFillAllInfo.onNext(false)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
}

private extension DailyInfoCreateViewModel {
    /* finish function by coordinator */
    // func finish() {}
    
    
}
