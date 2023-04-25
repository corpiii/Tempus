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
        let modelTitle: PublishSubject<String>
        let divideCount: PublishSubject<Int>
    }
    
    private var originModel: BlockModel {
        didSet {
            self.modelTitle.onNext(originModel.title)
            self.modelDivideCount.onNext(originModel.divideCount)
        }
    }
    
    private let modelTitle: PublishSubject<String>
    private let modelDivideCount: PublishSubject<Int>
    
    init(originModel: BlockModel) {
        self.modelTitle = .init()
        self.modelDivideCount = .init()
        self.originModel = originModel
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(modelTitle: modelTitle,
                            divideCount: modelDivideCount)
        
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
        
        return output
    }
}

extension BlockDetailViewModel: EditReflectDelegate {
    func reflect(_ model: Model) {
        if let model = model as? BlockModel {
            self.originModel = model
        }
    }
}
