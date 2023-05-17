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
            .subscribe(onNext: { [weak self] divideCount in
                guard let self else { return }
                self.divideCount = divideCount
            }).disposed(by: disposeBag)
    }
    
    func bindCompleteButtonTapEvent(_ completeEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        completeEvent
            .subscribe(onNext: { [weak self] completeAlert in
                guard let self = self,
                      let title = self.modelTitle, title.isEmpty == false,
                      let divideCount = self.divideCount else { return }
                
                let model = BlockModel(id: UUID(), title: title, divideCount: divideCount)
                self.modelCreateEvent.onNext(model)
                self.originModel = model
            }).disposed(by: disposeBag)
    }
    
    func bindStartEvent(_ startEvent: Observable<CompleteAlert>, _ disposeBag: DisposeBag) {
        startEvent.subscribe(onNext: { [weak self]completeAlert in
            guard let self,
                  let originModel = self.originModel else { return }
            
            switch completeAlert {
            case .completeWithStart:
                let startUseCase = BlockStartUseCase(originModel: originModel)
                /* coordinator finish and switch to ClockView with model or startUseCase */
                // delegate? or function?
                // delegate가 나을듯
            case .completeWithoutStart:
                return
                /* coordinaotr just finish */
            }
        }).disposed(by: disposeBag)
    }
   
}
