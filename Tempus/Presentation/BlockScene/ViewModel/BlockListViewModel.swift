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
    
    private var blockFetchUseCase: BlockFetchUseCase
    private var blockDeleteUseCase: BlockDeleteUseCase
    
    private var modelFetchEvent: PublishSubject<Void>!
    
    init(repository: DataManagerRepository, blockDeleteUseCase: BlockDeleteUseCase) {
        self.blockFetchUseCase = .init(repository: repository)
        self.blockDeleteUseCase = blockDeleteUseCase
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let fetchEvent = input.modelFetchEvent
        self.modelFetchEvent = fetchEvent
        
        let fetchUseCaseInput = BlockFetchUseCase.Input(fetchModelEvent: fetchEvent)
        let fetchUseCaseOutput = blockFetchUseCase.transform(input: fetchUseCaseInput,
                                                             disposeBag: disposeBag)
        
        let deleteUseCaseInput = BlockDeleteUseCase.Input(blockDeleteEvent: input.modelDeleteEvent,
                                                          blockFetchEvent: fetchEvent)
        blockDeleteUseCase.bind(input: deleteUseCaseInput, disposeBag: disposeBag)
        
        bindAddButton(input.addButtonEvent, disposeBag: disposeBag)
        
        return Output(blockModelArray: fetchUseCaseOutput.modelArrayObservable)
    }
    
    private func bindAddButton(_ addButtonEvent: Observable<Void>, disposeBag: DisposeBag) {
        addButtonEvent
            .subscribe(onNext: {
                // coordinator push to createViewModel by 'push(self.modelFetchEvent)' function
            }).disposed(by: disposeBag)
    }
}
