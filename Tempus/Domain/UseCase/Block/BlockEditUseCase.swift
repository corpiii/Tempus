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
        let isEditSuccess: PublishSubject<Bool> = .init()
    }
    
    private let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        bindModelEditEvent(input.modelEditEvent, to: output.isEditSuccess, disposeBag: disposeBag)
        
        return output
    }
}

private extension BlockEditUseCase {
    func bindModelEditEvent(_ editEvent: Observable<BlockModel>,
                            to isEditSuccess: PublishSubject<Bool>,
                            disposeBag: DisposeBag) {
        editEvent
            .subscribe(onNext: { model in
                if model.blockTime == -1 || model.title.isEmpty {
                    return isEditSuccess.onNext(false)
                }
                do {
                    try self.execute(model: model) {
                        isEditSuccess.onNext(true)
                    }
                } catch {
                    isEditSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func execute(model: BlockModel, _ completion: @escaping () -> Void) throws {
        try repository.update(model)
        completion()
    }
}
