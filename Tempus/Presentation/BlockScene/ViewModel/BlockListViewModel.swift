//
//  BlockListViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/18.
//

import RxCocoa
import RxRelay
import RxSwift

final class BlockListViewModel {
    struct Input {
        let addButtonEvent: Observable<Void>
        let modelDeleteEvent: Observable<BlockModel>
        let modelFetchEvent: PublishSubject<Void>
    }
    
    struct Output {
        let blockModelArray: BehaviorSubject<[BlockModel]> = .init(value: [])
        let isDeleteSuccess: PublishRelay<Bool> = .init()
    }
    
    private var blockFetchUseCase: BlockFetchUseCase
    private var blockDeleteUseCase: BlockDeleteUseCase
    
    private var modelFetchEvent: PublishSubject<Void>!
    
    init(repository: DataManagerRepository) {
        self.blockFetchUseCase = .init(repository: repository)
        self.blockDeleteUseCase = .init(repository: repository)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.modelFetchEvent = input.modelFetchEvent
        
        let fetchUseCaseInput = BlockFetchUseCase.Input(modelFetchEvent: input.modelFetchEvent)
        let fetchUseCaseOutput = blockFetchUseCase.transform(input: fetchUseCaseInput,
                                                             disposeBag: disposeBag)
        
        let deleteUseCaseInput = BlockDeleteUseCase.Input(modelDeleteEvent: input.modelDeleteEvent)
        let deleteUseCaseOutput = blockDeleteUseCase.transform(input: deleteUseCaseInput,
                                                               disposeBag: disposeBag)
        
        fetchUseCaseOutput.modelArrayObservable
            .bind(to: output.blockModelArray)
            .disposed(by: disposeBag)
        
        bindDeleteSuccess(deleteUseCaseOutput.isDeleteSuccess, to: output.isDeleteSuccess, disposeBag)
        bindAddButton(input.addButtonEvent, disposeBag: disposeBag)
        
        return output
    }
}

private extension BlockListViewModel {
    func bindDeleteSuccess(_ deleteEvent: PublishSubject<Bool>, to isDeleteSuccess: PublishRelay<Bool>, _ disposeBag: DisposeBag) {
        deleteEvent
            .subscribe(onNext: { [weak self] isSuccess in
                guard let self = self else { return }
                if isSuccess {
                    self.refresh()
                }
                
                isDeleteSuccess.accept(isSuccess)
            }).disposed(by: disposeBag)
    }
    
    func bindAddButton(_ addButtonEvent: Observable<Void>, disposeBag: DisposeBag) {
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
