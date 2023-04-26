//
//  BlockCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/20.
//

import Foundation

import RxSwift

final class BlockCreateViewModel {
    struct Input {
        let completeEvent: Observable<CompleteAlert>
        let modelTitle: Observable<String>
        let divideCount: Observable<Int>
    }
    
    struct Output {
        let isCreateSucess: Observable<Bool>
    }
    
    private var modelTitle: String?
    private var divideCount: Int?
    private let modelCreateEvent: PublishSubject<BlockModel> = .init()
    private let modelFetchEvent: PublishSubject<Void>
    private let disposeBag: DisposeBag = .init()
    
    private let createUseCase: BlockCreateUseCase
    
    init(repository: DataManagerRepository, modelFetchEvent: PublishSubject<Void>) {
        self.createUseCase = .init(repository: repository)
        self.modelFetchEvent = modelFetchEvent
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let createUseCaseInput = BlockCreateUseCase.Input(modelFetchEvent: self.modelFetchEvent,
                                                          modelCreate: modelCreateEvent)
        let createUseCaseOutput = createUseCase.transform(input: createUseCaseInput,
                                                          disposeBag: self.disposeBag)
        let output = Output(isCreateSucess: createUseCaseOutput.isCreateSuccess)
        
        bind(input, disposeBag)
        
        return output
    }
    
    /* finish function by coordinator */
    // func finish() {}
}

private extension BlockCreateViewModel {
    func bind(_ input: Input, _ disposeBag: DisposeBag) {
        input.modelTitle
            .subscribe(onNext: { [weak self] title in
                guard let self else { return }
                self.modelTitle = title
            }).disposed(by: disposeBag)
        
        input.divideCount
            .subscribe(onNext: { [weak self] divideCount in
                guard let self else { return }
                self.divideCount = divideCount
            }).disposed(by: disposeBag)
        
        input.completeEvent
            .subscribe(onNext: { [weak self] completeAlert in
                guard let self = self,
                      let title = self.modelTitle,
                      let divideCount = self.divideCount else { return }
                
                let model = BlockModel(id: UUID(), title: title, divideCount: divideCount)
                
                switch completeAlert {
                case .completeWithStart:
                    let startUseCase = BlockStartUseCase(originModel: model)
                    self.modelCreateEvent.onNext(model)
                    
                    /* coordinator finish and switch to ClockView with model or startUseCase */
                    // delegate? or function?
                    // delegate가 나을듯
                    
                case .completeWithoutStart:
                    self.modelCreateEvent.onNext(model)
                    
                    /* coordinaotr just finish */
                    
                }
            }).disposed(by: disposeBag)
    }
}
