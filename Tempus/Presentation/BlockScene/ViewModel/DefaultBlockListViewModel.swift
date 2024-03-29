//
//  DefaultBlockListViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/18.
//
import Foundation

import RxCocoa
import RxRelay
import RxSwift

final class DefaultBlockListViewModel: BlockListViewModel {
    struct Input {
        let addButtonEvent: Observable<Void>
        let modelDeleteEvent: Observable<BlockModel>
        let modelFetchEvent: Observable<Void>
        let modelTapEvent: Observable<BlockModel>
    }
    
    struct Output {
        let blockModelArray: BehaviorSubject<[BlockModel]> = .init(value: [])
        let isDeleteSuccess: PublishRelay<Result<BlockModel, DataManageError>> = .init()
    }
    
    private var blockFetchUseCase: BlockFetchUseCase
    private var blockDeleteUseCase: BlockDeleteUseCase
    
    private var modelFetchEvent: PublishSubject<Void> = .init()
    
    weak var coordinator: BlockListViewCoordinator?
    
    init(repository: DataManagerRepository) {
        self.blockFetchUseCase = .init(repository: repository)
        self.blockDeleteUseCase = .init(repository: repository)
    }
    
    func transform<InputType, OutputType>(input: InputType, disposeBag: DisposeBag) -> OutputType? {
        guard let input = input as? Input else {
            return nil
        }
        
        let output = Output()
        
        let fetchUseCaseInput = BlockFetchUseCase.Input(modelFetchEvent: modelFetchEvent)
        let fetchUseCaseOutput = blockFetchUseCase.transform(input: fetchUseCaseInput,
                                                             disposeBag: disposeBag)
        
        let deleteUseCaseInput = BlockDeleteUseCase.Input(modelDeleteEvent: input.modelDeleteEvent)
        let deleteUseCaseOutput = blockDeleteUseCase.transform(input: deleteUseCaseInput,
                                                               disposeBag: disposeBag)
        
        fetchUseCaseOutput.modelArrayObservable
            .bind(to: output.blockModelArray)
            .disposed(by: disposeBag)
        
        bindAddButton(input.addButtonEvent, disposeBag: disposeBag)
        bindDeleteSuccess(deleteUseCaseOutput.isDeleteSuccess, to: output.isDeleteSuccess, disposeBag)
        bindModelFetchEvent(input.modelFetchEvent, disposeBag: disposeBag)
        bindModelTapEvent(input.modelTapEvent, disposeBag: disposeBag)
        
        output.blockModelArray.onNext([])
        
        return output as? OutputType
    }
}

private extension DefaultBlockListViewModel {
    func bindDeleteSuccess(_ deleteEvent: PublishSubject<Result<BlockModel, DataManageError>>, to isDeleteSuccess: PublishRelay<Result<BlockModel, DataManageError>>, _ disposeBag: DisposeBag) {
        deleteEvent
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                isDeleteSuccess.accept(result)
                
                if case .success = result {
                    self.refresh()
                }
            }).disposed(by: disposeBag)
    }
    
    func bindAddButton(_ addButtonEvent: Observable<Void>, disposeBag: DisposeBag) {
        addButtonEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.coordinator?.pushCreateViewController(self)
            }).disposed(by: disposeBag)
    }
    
    func bindModelFetchEvent(_ modelFetchEvent: Observable<Void>, disposeBag: DisposeBag) {
        modelFetchEvent
            .subscribe(onNext: { [weak self] in
                self?.refresh()
            }).disposed(by: disposeBag)
    }
    
    func bindModelTapEvent(_ modelTapEvent: Observable<BlockModel>, disposeBag: DisposeBag) {
        modelTapEvent
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                self.coordinator?.pushDetailViewController(with: model)
            }).disposed(by: disposeBag)
    }
}

extension DefaultBlockListViewModel {
    func refresh() {
        modelFetchEvent.onNext(())
    }
}
