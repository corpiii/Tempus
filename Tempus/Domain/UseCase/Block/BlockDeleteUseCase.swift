//
//  BlockDeleteUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/01.
//

import RxSwift

final class BlockDeleteUseCase {
    struct Input {
        let modelDeleteEvent: Observable<BlockModel>
    }
    
    struct Output {
        let isDeleteSuccess: PublishSubject<Result<BlockModel, DataManageError>> = .init()
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

private extension BlockDeleteUseCase {
    func bindModelDeleteEvent(_ modelDeleteEvent: Observable<BlockModel>, to isDeleteSuccess: PublishSubject<Result<BlockModel, DataManageError>>, disposeBag: DisposeBag) {
        modelDeleteEvent
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                do {
                    try self.execute(model: model) {
                        isDeleteSuccess.onNext(.success(model))
                    }
                } catch {
                    isDeleteSuccess.onNext(.failure(.deleteFailure))
                }
            }).disposed(by: disposeBag)
    }
    
    
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.delete(model)
        completion()
    }
}
