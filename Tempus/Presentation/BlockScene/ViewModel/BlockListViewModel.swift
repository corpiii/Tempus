//
//  BlockListViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/18.
//

import Foundation

import RxSwift

final class BlockListViewModel {
    private weak var blockFetchUseCase: BlockFetchUseCase?
    private weak var blockDeleteUseCase: BlockDeleteUseCase?
    
    struct Input {
        let addButtonEvent: Observable<Void>
        let modelDeleteEvent: Observable<BlockModel>
        let modelFetchEvent: PublishSubject<Void>
    }
    
    struct Output {
        let blockModelArray: Observable<[BlockModel]>
    }
    
    init(blockFetchUseCase: BlockFetchUseCase, blockDeleteUseCase: BlockDeleteUseCase) {
        self.blockFetchUseCase = blockFetchUseCase
        self.blockDeleteUseCase = blockDeleteUseCase
    }
    
    func bind(input: Input, disPoseBag: DisposeBag) -> Output {
        guard let blockFetchUseCase, let blockDeleteUseCase else {
            fatalError()
        }
        
        let fetchUseCaseInput = BlockFetchUseCase.Input(fetchModelEvent: input.modelFetchEvent)
        let fetchUseCaseOutput = blockFetchUseCase.bind(input: fetchUseCaseInput,
                                                         disposeBag: disPoseBag)
        
        input.addButtonEvent
            .subscribe(onNext: {
                // coordinator push
            }).disposed(by: disPoseBag)
        
        input.modelDeleteEvent
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                
                do {
                    try self.blockDeleteUseCase?.execute(model: model, {
                        input.modelFetchEvent.onNext(())
                    })
                } catch {
                    
                }
            }).disposed(by: disPoseBag)
        
        return Output(blockModelArray: fetchUseCaseOutput.modelArrayObservable)
    }
}
