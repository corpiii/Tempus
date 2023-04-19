//
//  BlockFetchUseCaseMock.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/19.
//

import RxSwift

final class BlockFetchUseCaseMock: BlockFetchUseCase {
    struct Input {
        let fetchModelEvent: Observable<Void>
    }
    
    struct OutPut {
        let modelArrayObservable: Observable<[BlockModel]>
    }
    
    private var modelArrayObservable: BehaviorSubject<[BlockModel]> = .init(value: [])
    private let repository: DataManagerRepository
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> OutPut {
        input.fetchModelEvent
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                do {
                    let models = try self.repository.fetchAllBlockModel()
                    self.modelArrayObservable.onNext(models)
                } catch {
                    return
                }
            }).disposed(by: disposeBag)
        
        return OutPut(modelArrayObservable: modelArrayObservable)
    }
}
