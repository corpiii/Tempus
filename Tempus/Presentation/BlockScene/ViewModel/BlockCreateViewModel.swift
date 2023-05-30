//
//  BlockCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/20.
//

import Foundation

import RxSwift
import RxRelay

final class BlockCreateViewModel {
    struct Input {
        let modelTitle: Observable<String>
        let modelDivideCount: Observable<Int>
        let completeButtonTapEvent: Observable<Void>
        let backButtonEvent: Observable<Void>
        let startEvent: Observable<CompleteAlert>
    }
    
    struct Output {
        let isCreateSuccess: PublishRelay<Bool> = .init()
    }
    
    private var modelTitle: String?
    private var divideCount: Int?
    private let modelCreateEvent: PublishSubject<BlockModel> = .init()
    private var originModel: BlockModel?
    
    private let createUseCase: BlockCreateUseCase
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    weak var coordinator: BlockCreateCoordinator?
    
    init(repository: DataManagerRepository, fetchRefreshDelegate: FetchRefreshDelegate) {
        self.createUseCase = .init(repository: repository)
        self.fetchRefreshDelegate = fetchRefreshDelegate
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let createUseCaseInput = BlockCreateUseCase.Input(modelCreate: self.modelCreateEvent)
        let createUseCaseOutput = createUseCase.transform(input: createUseCaseInput,
                                                          disposeBag: disposeBag)
        
        bindCreateSuccess(createUseCaseOutput.isCreateSuccess,
                          to: output.isCreateSuccess,
                          disposeBag)
        bindModelTitle(input.modelTitle, disposeBag)
        bindDivideCount(input.modelDivideCount, disposeBag)
        bindCompleteButtonTapEvent(input.completeButtonTapEvent, disposeBag)
        bindBackButtonEvent(input.backButtonEvent, disposeBag)
        bindStartEvent(input.startEvent, disposeBag)
        
        return output
    }
    
    /* finish function by coordinator */
    // func finish() {}
}

private extension BlockCreateViewModel {
    func bindCreateSuccess(_ isCreateSuccess: Observable<Bool>,
                           to isCreateSuccessRelay: PublishRelay<Bool>,
                           _ disposeBag: DisposeBag) {
        isCreateSuccess
            .subscribe(onNext: { [weak self] isCreateSuccess in
                guard let self = self else { return }
                if isCreateSuccess {
                    self.fetchRefreshDelegate?.refresh()
                }
                
                isCreateSuccessRelay.accept(isCreateSuccess)
            }).disposed(by: disposeBag)
    }
    
    func bindModelTitle(_ modelTitle: Observable<String>, _ disposeBag: DisposeBag) {
        modelTitle
            .subscribe(onNext: { [weak self] title in
                guard let self else { return }
                self.modelTitle = title
            }).disposed(by: disposeBag)
    }
    
    func bindDivideCount(_ divideCount: Observable<Int>, _ disposeBag: DisposeBag) {
        divideCount
            .subscribe(onNext: { [weak self] timeInterval in
                guard let self else { return }
                self.divideCount = 24 / timeInterval
            }).disposed(by: disposeBag)
    }
    
    func bindCompleteButtonTapEvent(_ completeEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        completeEvent
            .subscribe(onNext: { [weak self] completeAlert in
                guard let self else { return }
                
                let title = self.modelTitle ?? ""
                let divideCount = self.divideCount ?? -1
                let model = BlockModel(id: UUID(), title: title, divideCount: divideCount)
                self.modelCreateEvent.onNext(model)
                self.originModel = model
            }).disposed(by: disposeBag)
    }
    
    func bindBackButtonEvent(_ backButtonEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        backButtonEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.coordinator?.finish()
            }).disposed(by: disposeBag)
    }
    
    func bindStartEvent(_ startEvent: Observable<CompleteAlert>, _ disposeBag: DisposeBag) {
        startEvent.subscribe(onNext: { [weak self]completeAlert in
            guard let self,
                  let originModel = self.originModel else { return }
            
            switch completeAlert {
            case .completeWithStart:
                let startUseCase = BlockStartUseCase(originModel: originModel)
                self.coordinator?.finish(with: startUseCase)
            case .completeWithoutStart:
                self.coordinator?.finish()
            }
        }).disposed(by: disposeBag)
    }
   
}
