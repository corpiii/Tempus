//
//  BlockFetchUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/18.
//

import RxSwift

final class BlockFetchUseCase {
    struct Input {
        let fetchModelEvent: Observable<Void>
    }
    
    struct OutPut {
        let modelArrayObservable: Observable<[BlockModel]>
    }
    
    private let repository: DataManagerRepository
    private var modelArrayObservable: BehaviorSubject<[BlockModel]> = .init(value: [])
    
    init(repository: DataManagerRepository) {
        self.repository = repository
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> OutPut {
        bind(input.fetchModelEvent, disposeBag: disposeBag)
        return OutPut(modelArrayObservable: modelArrayObservable)
    }
}

private extension BlockFetchUseCase {
    func bind(_ fetchModelEvent: Observable<Void>, disposeBag: DisposeBag) {
        fetchModelEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                do {
                    try self.execute { models in
                        self.modelArrayObservable.onNext(models)
                    }
                } catch {
//                    self.modelArrayObservable.onError(error)
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    
    func execute(_ completion: @escaping ([BlockModel]) -> Void) throws {
        let models = try repository.fetchAllBlockModel()
        completion(models)
    }
}
