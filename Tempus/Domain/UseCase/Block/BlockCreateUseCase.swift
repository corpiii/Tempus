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
        let modelFetchEvent: PublishSubject<Void>
        let modelCreate: Observable<BlockModel>
    }
    
    struct Output {
        let isCreateSuccess: PublishSubject<Bool>
    }
    
    private let isCreateSuccess: PublishSubject<Bool> = .init()
    private let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(isCreateSuccess: isCreateSuccess)
        
        bind(input, disposeBag, isCreateSuccess)
        
        return output
    }
}

private extension BlockCreateUseCase {
    func bind(_ input: Input, _ disposeBag: DisposeBag, _ isCreateSuccess: PublishSubject<Bool>) {
        input.modelCreate
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                do {
                    try self.execute(model: model) {
                        input.modelFetchEvent.onNext(())
                        isCreateSuccess.onNext(true)
                    }
                } catch {
                    isCreateSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.create(model)
        completion()
    }
}
