//
//  DailyDeleteUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/02.
//

import RxSwift

final class DailyDeleteUseCase {
    struct Input {
        let modelDeleteEvent: Observable<DailyModel>
    }
    
    struct Output {
        let isDeleteSuccess: PublishSubject<Bool> = .init()
    }
    
    private let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        bindModelDeleteEvent(input.modelDeleteEvent, to: output.isDeleteSuccess, disposeBag: disposeBag)
        
        return output
    }
}

private extension DailyDeleteUseCase {
    func bindModelDeleteEvent(_ modelDeleteEvent: Observable<DailyModel>, to isDeleteSuccess: PublishSubject<Bool>, disposeBag: DisposeBag) {
        modelDeleteEvent
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                do {
                    try self.execute(model: model) {
                        isDeleteSuccess.onNext(true)
                    }
                } catch {
                    isDeleteSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    
    func execute(model: DailyModel, _ completion: @escaping () -> Void) throws {
        try repository.delete(model)
        completion()
    }
}
