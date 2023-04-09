//
//  BlockStartUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/07.
//

import Foundation

import RxSwift

final class BlockStartUseCase {
    private var time: Time {
        didSet {
            timeObservable.onNext(time)
        }
    }
    private let timeObservable: PublishSubject<Time> = .init()
    private let originModel: BlockModel
    private var schedule: [Date] = []
    
    init(originModel: BlockModel) {
        self.originModel = originModel
        self.time = Time(second: 0)
    }
}

extension BlockStartUseCase: ModeInfo {
    var type: ModeType {
        return .block
    }
    
    func fetchTimeObservable() -> PublishSubject<Time> {
        return timeObservable
    }
}

extension BlockStartUseCase: ModeController {
    func modeStart() {
    }
    
    func modeStop() {
        
    }
    
}
