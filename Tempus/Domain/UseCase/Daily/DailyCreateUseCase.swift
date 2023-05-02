//
//  DailyCreateUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/01.
//

import RxSwift

final class DailyCreateUseCase {
    struct Input {
        let modelCreate: Observable<DailyModel>
    }
    
    struct Output {
        let isCreateSuccess: PublishSubject<Bool> = .init()
    }
    
    private let repository: DataManagerRepository
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        bindModelCreate(input.modelCreate, to: output.isCreateSuccess, disposeBag)
        
        return output
    }
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
}

private extension DailyCreateUseCase {
    func bindModelCreate(_ modelCreate: Observable<DailyModel>,
                         to isCreateSuccess: PublishSubject<Bool>,
                         _ disposeBag: DisposeBag) {
        modelCreate
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                do {
                    try self.execute(model: model) {
                        isCreateSuccess.onNext(true)
                    }
                } catch {
                    isCreateSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func execute(model: DailyModel, _ completion: @escaping () -> Void) throws {
        try repository.create(model)
        completion()
    }
}
