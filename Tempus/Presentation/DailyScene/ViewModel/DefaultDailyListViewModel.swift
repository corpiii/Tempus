//
//  DefaultDailyListViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/28.
//

import RxCocoa
import RxRelay
import RxSwift

final class DefaultDailyListViewModel: DailyListViewModel {
    struct Input {
        let addButtonEvent: Observable<Void>
        let modelDeleteEvent: Observable<DailyModel>
        let modelFetchEvent: PublishSubject<Void>
        let modelTapEvent: PublishSubject<DailyModel>
    }
    
    struct Output {
        let dailyModelArray: BehaviorSubject<[DailyModel]> = .init(value: [])
        let isDeleteSuccess: PublishRelay<Result<DailyModel, DataManageError>> = .init()
    }
    
    private var dailyFetchUseCase: DailyFetchUseCase
    private var dailyDeleteUseCase: DailyDeleteUseCase
    
    private var modelFetchEvent: PublishSubject<Void>!
    weak var coordinator: DailyListViewCoordinator?
    
    init(repository: DataManagerRepository) {
        self.dailyFetchUseCase = .init(repository: repository)
        self.dailyDeleteUseCase = .init(repository: repository)
    }
    
    func transform<InputType, OutputType>(input: InputType, disposeBag: DisposeBag) -> OutputType? {
        guard let input = input as? Input else {
            return nil
        }
        
        let output = Output()
        self.modelFetchEvent = input.modelFetchEvent
        
        let fetchUseCaseInput = DailyFetchUseCase.Input(modelFetchEvent: input.modelFetchEvent)
        let fetchUseCaseOutput = dailyFetchUseCase.transform(input: fetchUseCaseInput,
                                                             disposeBag: disposeBag)
        
        let deleteUseCaseInput = DailyDeleteUseCase.Input(modelDeleteEvent: input.modelDeleteEvent)
        let deleteUseCaseOutput = dailyDeleteUseCase.transform(input: deleteUseCaseInput,
                                                               disposeBag: disposeBag)
        fetchUseCaseOutput.modelArrayObservable
            .bind(to: output.dailyModelArray)
            .disposed(by: disposeBag)
        
        bindDeleteSuccess(deleteUseCaseOutput.isDeleteSuccess, to: output.isDeleteSuccess, disposeBag)
        bindAddButton(input.addButtonEvent, disposeBag: disposeBag)
        bindModelTapEvent(input.modelTapEvent, disposeBag: disposeBag)
        
        return output as? OutputType
    }
}

private extension DefaultDailyListViewModel {
    func bindDeleteSuccess(_ deleteEvent: PublishSubject<Result<DailyModel, DataManageError>>, to isDeleteSuccess: PublishRelay<Result<DailyModel, DataManageError>>, _ disposeBag: DisposeBag) {
        deleteEvent
            .subscribe(onNext: { [weak self] result in
                isDeleteSuccess.accept(result)
                
                if case .success = result {
                    self?.refresh()
                }
            }).disposed(by: disposeBag)
    }
    
    func bindAddButton(_ addButtonEvent: Observable<Void>, disposeBag: DisposeBag) {
        addButtonEvent
            .subscribe(onNext: {
                self.coordinator?.pushInfoCreateViewController(fetchRefreshDelegate: self)
            }).disposed(by: disposeBag)
    }
    
    func bindModelTapEvent(_ modelTapEvent: PublishSubject<DailyModel>, disposeBag: DisposeBag) {
        modelTapEvent
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                self.coordinator?.pushDetailViewController(originModel: model, fetchRefreshDelegate: self)
            }).disposed(by: disposeBag)
    }
}

extension DefaultDailyListViewModel {
    func refresh() {
        modelFetchEvent.onNext(())
    }
}
