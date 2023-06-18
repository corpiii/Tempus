//
//  DailyInfoEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/05.
//

import Foundation

import RxSwift

final class DailyInfoEditViewModel {
    struct Input {
        let cancelButtonTapEvent: Observable<Void>
        let nextButtonTapEvent: Observable<Void>
        
        let modelTitle: Observable<String>
        let modelFocusTime: Observable<Date>
        let modelBreakTime: Observable<Date>
    }
    
    struct Output {
        let modelTitle: String
        let modelFocusTime: Date
        let modelBreakTime: Date
        let isFillAllInfo: PublishSubject<Bool> = .init()
    }
    
    private var modelTitle: String?
    private var modelFocusTime: Double?
    private var modelBreakTime: Double?
    
    private var originModel: DailyModel
    
    init(originModel: DailyModel) {
        self.originModel = originModel
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let startDay = -9.0 * 60 * 60 // Date의 시작시간은 09시
        let focusTime = Date(timeIntervalSince1970: startDay + originModel.focusTime)
        let breakTime = Date(timeIntervalSince1970: startDay + originModel.breakTime)
        
        let output = Output(modelTitle: originModel.title, modelFocusTime: focusTime, modelBreakTime: breakTime)
        
        bindModelTitle(input.modelTitle, disposeBag)
        bindModelFocusTime(input.modelFocusTime, disposeBag)
        bindModelBreakTime(input.modelBreakTime, disposeBag)
        
        bindNextButtonTapEvent(input.nextButtonTapEvent, to: output.isFillAllInfo, disposeBag)
        bindCancelButtonTapEvent(input.cancelButtonTapEvent, disposeBag)
        
        return output
    }
}

private extension DailyInfoEditViewModel {
    func bindModelTitle(_ modelTitle: Observable<String>, _ disposeBag: DisposeBag) {
        modelTitle
            .subscribe(onNext: { [weak self] title in
                self?.modelTitle = title
            }).disposed(by: disposeBag)
    }
    
    func bindModelFocusTime(_ modelFocusTime: Observable<Date>, _ disposeBag: DisposeBag) {
        modelFocusTime
            .subscribe(onNext: { [weak self] focusTime in
//                self?.modelFocusTime = focusTime
            }).disposed(by: disposeBag)
    }
    
    func bindModelBreakTime(_ modelBreakTime: Observable<Date>, _ disposeBag: DisposeBag) {
        modelBreakTime
            .subscribe(onNext: { [weak self] breakTime in
//                self?.modelBreakTime = breakTime
            }).disposed(by: disposeBag)
    }
    
    func bindNextButtonTapEvent(_ nextButtonTapEvent: Observable<Void>,
                                to isFillAllInfo: PublishSubject<Bool>,
                                _ disposeBag: DisposeBag) {
        nextButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self,
                      let modelTitle = self.modelTitle,
                      let modelFocusTime = self.modelFocusTime,
                      let modelBreakTime = self.modelBreakTime else {
                    return isFillAllInfo.onNext(false)
                }
                
                self.originModel.title = modelTitle
                self.originModel.focusTime = modelFocusTime
                self.originModel.breakTime = modelBreakTime
                
                isFillAllInfo.onNext(true)
                // coordinator push
            }).disposed(by: disposeBag)
    }
    
    func bindCancelButtonTapEvent(_ cancelButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        cancelButtonTapEvent
            .subscribe(onNext: { [weak self] in
                
                // coordinator pop
            }).disposed(by: disposeBag)
    }

}
