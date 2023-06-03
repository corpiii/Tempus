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
        
        bindModelCreate(input.modelCreate, to: output.isCreateSuccess, disposeBag)
        
        return output
    }
}

private extension BlockCreateUseCase {
    func bindModelCreate(_ modelCreate: Observable<BlockModel>,
                         to isCreateSuccess: PublishSubject<Bool>,
                         _ disposeBag: DisposeBag) {
        modelCreate
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                if model.blockTime == -1 || model.title.isEmpty {
                    return isCreateSuccess.onNext(false)
                }
                
                do {
                    try self.execute(model: model) {
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
