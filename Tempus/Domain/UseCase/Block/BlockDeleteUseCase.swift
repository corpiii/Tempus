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
        let isDeleteSuccess: PublishSubject<Bool> = .init()
    }
    
    private let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.modelDeleteEvent
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                do {
                    try self.execute(model: model) {
                        output.isDeleteSuccess.onNext(true)
                    }
                } catch {
                    output.isDeleteSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
}

private extension BlockDeleteUseCase {
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.delete(model)
        completion()
    }
}
