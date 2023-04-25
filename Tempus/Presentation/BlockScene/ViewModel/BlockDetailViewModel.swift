//
//  BlockDetailViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/25.
//

import Foundation

import RxSwift

final class BlockDetailViewModel {
    struct Input {
        let startButtonTapEvent: Observable<Void>
        let editButtonTapEvent: Observable<Void>
        let cancelButtonTapEvent: Observable<Void>
    }
    
    private let originModel: BlockModel
    
    init(originModel: BlockModel) {
        self.originModel = originModel
    }
    
    func bind(input: Input, disposeBag: DisposeBag) {
        input.startButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                let startUseCase = BlockStartUseCase(originModel: self.originModel)
                // coordinator push with startUseCase
            }).disposed(by: disposeBag)
        
        input.editButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                // coordinator push with originModel
                // and push with self and refresh with edited Data
            }).disposed(by: disposeBag)
        
        input.cancelButtonTapEvent
            .subscribe(onNext: {
                // coordinator finish
            }).disposed(by: disposeBag)
    }
}
