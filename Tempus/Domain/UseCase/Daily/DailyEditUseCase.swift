//
//  DailyEditUseCase.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/01.
//

import RxSwift

final class DailyEditUseCase {
    struct Input {
        let modelEditEvent: Observable<DailyModel>
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

private extension DailyEditUseCase {
    func bindModelEditEvent(_ editEvent: Observable<DailyModel>,
                            to isEditSuccess: PublishSubject<Bool>,
                            disposeBag: DisposeBag) {
        editEvent
            .subscribe(onNext: { model in
                do {
                    try self.execute(model: model) {
                        isEditSuccess.onNext(true)
                    }
                } catch {
                    isEditSuccess.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    func execute(model: DailyModel, _ completion: @escaping () -> Void) throws {
        try repository.update(model)
        completion()
    }
}
