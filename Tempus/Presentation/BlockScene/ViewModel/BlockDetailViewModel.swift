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
    
    struct Output {
        let originModelSubject: BehaviorSubject<BlockModel>
    }
    
    private let originModelSubject: BehaviorSubject<BlockModel>
    
    init(originModel: BlockModel) {
        self.originModelSubject = .init(value: originModel)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(originModelSubject: originModelSubject)
        
        input.startButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self,
                      let originModel = try? self.originModelSubject.value() else { return }
                
                let startUseCase = BlockStartUseCase(originModel: originModel)
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
        
        return output
    }
}

extension BlockDetailViewModel: EditReflectDelegate {
    func reflect(_ model: Mode) {
        if let model = model as? BlockModel {
            self.originModelSubject.onNext(model)
        }
    }
}
