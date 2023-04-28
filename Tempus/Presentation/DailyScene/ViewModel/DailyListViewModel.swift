//
//  DailyListViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/28.
//

import RxCocoa
import RxRelay
import RxSwift

final class DailyListViewModel {
    struct Input {
        let addButtonEvent: Observable<Void>
        let modelDeleteEvent: Observable<DailyModel>
        let modelFetchEvent: PublishSubject<Void>
    }
    
    struct Output {
        let dailyModelArray: BehaviorSubject<[DailyModel]> = .init(value: [])
        let isDeleteSuccess: PublishRelay<Bool> = .init()
    }
    
    private var dailyFetchUseCase: DailyFetchUseCase
    private var dailyDeleteUseCase: DailyDeleteUseCase
    
    private var modelFetchEvent: PublishSubject<Void>!
    
    init(repository: DataManagerRepository) {
        self.dailyFetchUseCase = .init(repository: repository)
        self.dailyDeleteUseCase = .init(repository: repository)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
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
        
        bindDeleteSuccess(deleteUseCaseOutput.isDeleteSuccess, disposeBag)
        bindAddButton(input.addButtonEvent, disposeBag: disposeBag)
        
        return output
    }
}

private extension DailyListViewModel {
    func bindDeleteSuccess(_ isDeleteSuccess: PublishSubject<Bool>, _ disposeBag: DisposeBag) {
        isDeleteSuccess
            .subscribe(onNext: { [weak self] isSuccess in
                guard let self = self else { return }
                if isSuccess {
                    self.refresh()
                }
            }).disposed(by: disposeBag)
    }
    
    func bindAddButton(_ addButtonEvent: Observable<Void>, disposeBag: DisposeBag) {
        addButtonEvent
            .subscribe(onNext: {
                // coordinator push to createViewModel by 'push(fetchRefreshDelegate: self)' function
            }).disposed(by: disposeBag)
    }
}

extension DailyListViewModel: FetchRefreshDelegate {
    func refresh() {
        modelFetchEvent.onNext(())
    }
}
