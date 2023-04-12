//
//  ClockStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/12.
//

import Foundation

import RxSwift

final class ClockStartUseCase {
    struct Input {
        let modeStartButtonTappedEvent: Observable<Void>
        let modeStopButtonTappedEvent: Observable<Void>
    }
    
    struct Output {
        let timeObservable: PublishSubject<Time>
    }
    
    var modeInfoDelegate: ModeInfo?
    var modeControllerDelegate: ModeController?
    var disposeBag: DisposeBag = DisposeBag()
    
    func modeStop() {
        guard let modeControllerDelegate = modeControllerDelegate else {
            return
        }
        
        modeControllerDelegate.modeStop()
    }
    
    func bind(to input: Input) throws -> Output {
//        guard let modeInfoDelegate = modeInfoDelegate,
//              let modeControllerDelegate = modeControllerDelegate else {
//            throw Error
//        }
        
        let output = Output(timeObservable: modeInfoDelegate.fetchTimeObservable())
        
        
        input.modeStartButtonTappedEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let modeControllerDelegate = self.modeControllerDelegate else {
                    return
                }
                
                modeControllerDelegate.modeStart()
            }).disposed(by: disposeBag)
        
        input.modeStopButtonTappedEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let modeControllerDelegate = self.modeControllerDelegate else {
                    return
                }
                
                modeControllerDelegate.modeStop()
            }).disposed(by: disposeBag)
        
        return output
    }
}
