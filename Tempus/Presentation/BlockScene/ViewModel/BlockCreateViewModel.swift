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
        let completeEvent: Observable<CompleteAlert>
        let modelTitle: Observable<String>
        let divideCount: Observable<Int>
    }
    
    struct Output {
        let isCreateSuccess: PublishRelay<Bool> = .init()
    }
    
    private var modelTitle: String?
    private var divideCount: Int?
    private let modelCreateEvent: PublishSubject<BlockModel> = .init()
    
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
        bindDivideCount(input.divideCount, disposeBag)
        bindCompleteEvent(input.completeEvent, disposeBag)
        
        return output
    }
    
    /* finish function by coordinator */
    // func finish() {}
}

private extension BlockCreateViewModel {
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
    
    func bindCompleteEvent(_ completeEvent: Observable<CompleteAlert>, _ disposeBag: DisposeBag) {
        completeEvent
            .subscribe(onNext: { [weak self] completeAlert in
                guard let self = self,
                      let title = self.modelTitle,
                      let divideCount = self.divideCount else { return }
                
                let model = BlockModel(id: UUID(), title: title, divideCount: divideCount)
                
                switch completeAlert {
                case .completeWithStart:
                    let startUseCase = BlockStartUseCase(originModel: model)
                    self.modelCreateEvent.onNext(model)
                    
                    /* coordinator finish and switch to ClockView with model or startUseCase */
                    // delegate? or function?
                    // delegate가 나을듯
                    
                case .completeWithoutStart:
                    self.modelCreateEvent.onNext(model)
                    
                    /* coordinaotr just finish */
                    
                }
            }).disposed(by: disposeBag)
    }
    
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
}
