//
//  ModeController.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/04.
//

import RxSwift

protocol ModeTransform {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output
}

extension ModeTransform {
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        return Output.self as! Self.Output
    }
}

class ModeStartUseCase: ModeTransform {
    struct Input {
        let modeStartEvent: Observable<Void>
        let modeStopEvent: Observable<Void>
    }
    
    struct Output {
        let remainTime: PublishSubject<Time>
        let modeState: PublishSubject<ModeState>
    }
}
