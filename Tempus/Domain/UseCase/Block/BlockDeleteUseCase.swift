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
        let modelFetchEvent: PublishSubject<Void>
    }
    
    struct Output {
        let isDeleteSuccess: PublishSubject<Bool>
    }
    
    private let repository: DataManagerRepository
    private let isDeleteSuccess: PublishSubject<Bool> = .init()
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(isDeleteSuccess: isDeleteSuccess)
        
        bind(input: input, disposeBag: disposeBag)
        
        return output
    }
}

private extension BlockDeleteUseCase {
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.delete(model)
        completion()
    }
    
    func bind(input: Input, disposeBag: DisposeBag) {
        input.modelDeleteEvent
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                do {
                    try self.execute(model: model) {
                        self.isDeleteSuccess.onNext(true)
                        input.modelFetchEvent.onNext(())
                    }
                } catch {
                    self.isDeleteSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
}
