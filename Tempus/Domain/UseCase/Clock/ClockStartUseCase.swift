//
//  ClockStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/12.
//

import Foundation

import RxSwift

//final class ClockStartUseCase {
//    struct Input {
//        let modeStartEvent: Observable<Void>
//        let modeStopEvent: Observable<Void>
//    }
//
//    struct Output {
//        let remainTime: PublishSubject<Time>
//        let modeState: PublishSubject<ModeState>
//    }
//
//    var modeStartUseCase: ModeStartUseCase?
//
//    func transform(to input: Input, disposeBag: DisposeBag) -> Output {
//        input.modeStartEvent
//            .subscribe(onNext: { [weak self] in
//                guard let self,
//                      let modeStartUseCase = self.modeStartUseCase else {
//                    return
//                }
//
//
//            }).disposed(by: disposeBag)
//        let startUseCaseInput = ModeStartUseCase.Input(modeStartEvent: input.modeStartEvent,
//                                                       modeStopEvent: input.modeStopEvent)
//
//        let startUseCaseOutput = modeStartUseCase.transform(to: startUseCaseInput)
//
//        let output = Output(remainTime: startUseCaseOutput.remainTime,
//                            modeState: startUseCaseOutput.modeState)
//
//        return output
//    }
//}
//
//private extension ClockStartUseCase {
//    func bindToStartUseCase(input: ModeStartUseCase.Input, disposeBag: DisposeBag) -> ModeStartUseCase.Output {
//
//    }
//}
