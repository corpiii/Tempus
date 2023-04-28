//
//  BlockListViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/18.
//

import RxSwift

protocol FetchRefreshDelegate: AnyObject {
    func refresh()
}

final class BlockListViewModel {
    struct Input {
        let addButtonEvent: Observable<Void>
        let modelDeleteEvent: Observable<BlockModel>
        let modelFetchEvent: PublishSubject<Void>
    }
    
    struct Output {
        let blockModelArray: Observable<[BlockModel]>
        let isDeleteSuccess: Observable<Bool>
    }
    
    private var blockFetchUseCase: BlockFetchUseCase
    private var blockDeleteUseCase: BlockDeleteUseCase
    
    private var modelFetchEvent: PublishSubject<Void>!
    
    init(repository: DataManagerRepository) {
        self.blockFetchUseCase = .init(repository: repository)
        self.blockDeleteUseCase = .init(repository: repository)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let fetchEvent = input.modelFetchEvent
        self.modelFetchEvent = fetchEvent
        
        let fetchUseCaseInput = BlockFetchUseCase.Input(modelFetchEvent: fetchEvent)
        let fetchUseCaseOutput = blockFetchUseCase.transform(input: fetchUseCaseInput,
                                                             disposeBag: disposeBag)
        
        let deleteUseCaseInput = BlockDeleteUseCase.Input(modelDeleteEvent: input.modelDeleteEvent,
                                                          modelFetchEvent: fetchEvent)
        let deleteUseCaseOutput = blockDeleteUseCase.transform(input: deleteUseCaseInput,
                                                               disposeBag: disposeBag)
        
        bindAddButton(input.addButtonEvent, disposeBag: disposeBag)
        
        return Output(blockModelArray: fetchUseCaseOutput.modelArrayObservable,
                      isDeleteSuccess: deleteUseCaseOutput.isDeleteSuccess)
    }
    
    private func bindAddButton(_ addButtonEvent: Observable<Void>, disposeBag: DisposeBag) {
        addButtonEvent
            .subscribe(onNext: {
                // coordinator push to createViewModel by 'push(fetchRefreshDelegate: self)' function
            }).disposed(by: disposeBag)
    }
}

extension BlockListViewModel: FetchRefreshDelegate {
    func refresh() {
        modelFetchEvent.onNext(())
    }
}
