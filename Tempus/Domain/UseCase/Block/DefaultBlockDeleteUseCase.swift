//
//  BlockDeleteUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/01.
//

import RxSwift

protocol BlockFetchUseCase {
    associatedtype Input
    associatedtype OutPut
    
    func transform(input: Input, disposeBag: DisposeBag) -> OutPut
}

final class DefaultBlockDeleteUseCase {
    struct Input {
        let blockDeleteEvent: Observable<BlockModel>
        let blockFetchEvent: PublishSubject<Void>
    }
    
    private let repository: DataManagerRepository
    private weak var fetchDelegate: FetchDelegate?
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func bind(input: Input, disposeBag: DisposeBag) {
        input.blockDeleteEvent
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                do {
                    try self.execute(model: model) {
                        input.blockFetchEvent.onNext(())
                    }
                } catch {
                    
                }
            }).disposed(by: disposeBag)
    }
}

private extension DefaultBlockDeleteUseCase {
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.delete(model)
        completion()
    }
}
