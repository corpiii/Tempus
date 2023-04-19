//
//  BlockListViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/18.
//

import RxSwift

final class BlockListViewModel {
    struct Input {
        let addButtonEvent: Observable<Void>
        let modelDeleteEvent: Observable<BlockModel>
        let modelFetchEvent: PublishSubject<Void>
    }
    
    struct Output {
        let blockModelArray: Observable<[BlockModel]>
    }
    
    weak var blockFetchUseCase: BlockFetchUseCase?
    weak var blockDeleteUseCase: BlockDeleteUseCase?
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        guard let blockFetchUseCase, let blockDeleteUseCase else {
            fatalError()
        }
        
        let fetchUseCaseInput = BlockFetchUseCase.Input(fetchModelEvent: input.modelFetchEvent)
        let fetchUseCaseOutput = blockFetchUseCase.transform(input: fetchUseCaseInput,
                                                             disposeBag: disposeBag)
        
        let deleteUseCaseInput = BlockDeleteUseCase.Input(blockDeleteEvent: input.modelDeleteEvent,
                                                          blockFetchEvent: input.modelFetchEvent)
        blockDeleteUseCase.bind(input: deleteUseCaseInput, disposeBag: disposeBag)
        
        bindAddButton(input.addButtonEvent, disposeBag: disposeBag)
        
        return Output(blockModelArray: fetchUseCaseOutput.modelArrayObservable)
    }
    
    private func bindAddButton(_ addButtonEvent: Observable<Void>, disposeBag: DisposeBag) {
        addButtonEvent
            .subscribe(onNext: {
                // coordinator push
            }).disposed(by: disposeBag)
    }

}
