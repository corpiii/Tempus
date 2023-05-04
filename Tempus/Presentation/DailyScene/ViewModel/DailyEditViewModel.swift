//
//  DailyEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/05.
//

import Foundation

import RxSwift

final class DailyEditViewModel {
    struct Input {
        let modelTitle: Observable<String>
        let modelFocusTime: Observable<Double>
        let modelBreakTime: Observable<Double>
    }
    
    struct Output {
        let isFillAllInfo: PublishSubject<Bool> = .init()
    }
    
    private var originModel: DailyModel
    
    init(originModel: DailyModel) {
        self.originModel = originModel
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}

