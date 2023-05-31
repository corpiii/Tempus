//
//  BlockDetailViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/25.
//

import RxSwift

final class BlockDetailViewModel {
    struct Input {
        let startButtonTapEvent: Observable<Void>
        let editButtonTapEvent: Observable<Void>
        let cancelButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let originModelSubject: BehaviorSubject<BlockModel>
    }
    
    private let originModelSubject: BehaviorSubject<BlockModel>
    weak var coordinator: BlockDetailCoordinator?
    
    init(originModel: BlockModel) {
        self.originModelSubject = .init(value: originModel)
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(originModelSubject: originModelSubject)
        
        bindStartButtonTapEvent(input.startButtonTapEvent, disposeBag)
        bindEditButtonTapEvent(input.editButtonTapEvent, disposeBag)
        bindCancelButtonTapEvent(input.cancelButtonTapEvent, disposeBag)
        
        return output
    }
}

private extension BlockDetailViewModel {
    func bindStartButtonTapEvent(_ startEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        startEvent
            .subscribe(onNext: { [weak self] in
                guard let self,
                      let originModel = try? self.originModelSubject.value() else { return }
                
                let startUseCase = BlockStartUseCase(originModel: originModel)
                self.coordinator?.finish(with: startUseCase)
            }).disposed(by: disposeBag)
    }
    
    func bindEditButtonTapEvent(_ editEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        editEvent
            .subscribe(onNext: { [weak self] in
                guard let self,
                      let originModel = try? self.originModelSubject.value() else { return }
                self.coordinator?.pushBlockEditViewController(with: originModel)
            }).disposed(by: disposeBag)
    }
    
    func bindCancelButtonTapEvent(_ cancelEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        cancelEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.coordinator?.finish()
            }).disposed(by: disposeBag)
    }
}

extension BlockDetailViewModel: EditReflectDelegate {
    func reflect(_ model: Mode) {
        if let model = model as? BlockModel {
            self.originModelSubject.onNext(model)
        }
    }
}
