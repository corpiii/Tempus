//
//  BlockCreateUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/31.
//

import Foundation

import RxSwift

final class BlockCreateUseCase {
    struct Input {
        let modelCreate: Observable<BlockModel>
    }
    
    struct Output {
        let isCreateSuccess: PublishSubject<Bool> = .init()
    }
    
    private let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.modelCreate
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                do {
                    try self.execute(model: model) {
                        output.isCreateSuccess.onNext(true)
                    }
                } catch {
                    output.isCreateSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
}

private extension BlockCreateUseCase {
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.create(model)
        completion()
    }
}
