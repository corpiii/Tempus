//
//  BlockEditUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/31.
//

import Foundation

import RxSwift

final class BlockEditUseCase {
    struct Input {
        let modelEditEvent: Observable<BlockModel>
    }
    
    struct Output {
        let isEditSuccess: PublishSubject<Bool>
    }
    
    private let isEditSuccess: PublishSubject<Bool> = .init()
    private let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(isEditSuccess: isEditSuccess)
        
        input.modelEditEvent
            .subscribe(onNext: { [weak self] model in
                guard let self else { return }
                do {
                    try self.execute(model: model) {
                        self.isEditSuccess.onNext(true)
                    }
                } catch {
                    self.isEditSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
}

private extension BlockEditUseCase {
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.update(model)
        completion()
    }
}
