//
//  BlockEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/26.
//

import Foundation

import RxSwift

final class BlockEditViewModel {
    struct Input {
        let modelTitle: Observable<String>
        let modelDivideCount: Observable<Int>
        let completeButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let isEditSuccess: PublishSubject<Bool>
    }
    
    private var originModel: BlockModel
    private var modelTitle: String?
    private var modelDivideCount: Int?
    private let blockEditUseCase: BlockEditUseCase
    private let completeButtonTapEvent: PublishSubject<BlockModel> = .init()
    private let modelFetchEvent: PublishSubject<Void>
    
    init(originModel: BlockModel, repository: DataManagerRepository, modelFetchEvent: PublishSubject<Void>) {
        self.originModel = originModel
        self.blockEditUseCase = .init(repository: repository)
        self.modelFetchEvent = modelFetchEvent
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let editUseCaseInput = BlockEditUseCase.Input(modelEditEvent: self.completeButtonTapEvent,
                                                      modelFetchEvent: self.modelFetchEvent)
        let editUSeCaseOutput = blockEditUseCase.transform(input: editUseCaseInput,
                                                           disposeBag: disposeBag)
        
        let output = Output(isEditSuccess: editUSeCaseOutput.isEditSuccess)
        
        input.modelTitle
            .subscribe(onNext: { [weak self] modelTitle in
                guard let self else { return }
                self.modelTitle = modelTitle
            }).disposed(by: disposeBag)
        
        input.modelDivideCount
            .subscribe(onNext: { [weak self] modelDivideCount in
                guard let self else { return }
                self.modelDivideCount = modelDivideCount
            }).disposed(by: disposeBag)
        
        input.completeButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self,
                      let modelTitle = self.modelTitle,
                      let modelDivideCount = self.modelDivideCount else { return }
                
                self.originModel.title = modelTitle
                self.originModel.divideCount = modelDivideCount
                
                self.completeButtonTapEvent.onNext(self.originModel)
            }).disposed(by: disposeBag)
        
        return output
    }
}
