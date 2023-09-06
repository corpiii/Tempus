//
//  DefaultBlockCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/20.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultBlockCreateViewModel: BlockCreateViewModel {
    struct Input {
        let modelTitle: Observable<String>
        let modelBlockTime: Observable<Int>
        let completeButtonTapEvent: Observable<Void>
        let cancelButtonTapEvent: Observable<Void>
        let startEvent: Observable<CompleteAlert>
    }
    
    struct Output {
        let isCreateSuccess: PublishRelay<Bool> = .init()
    }
    
    private var modelTitle: String?
    private var modelBlockTime: Int?
    private let modelCreateEvent: PublishSubject<BlockModel> = .init()
    private var originModel: BlockModel?
    
    private let createUseCase: BlockCreateUseCase
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    weak var coordinator: BlockCreateCoordinator?
    
    init(repository: DataManagerRepository, fetchRefreshDelegate: FetchRefreshDelegate) {
        self.createUseCase = .init(repository: repository)
        self.fetchRefreshDelegate = fetchRefreshDelegate
    }
    
    func transform<InputType, OutputType>(input: InputType, disposeBag: RxSwift.DisposeBag) -> OutputType? {
        guard let input = input as? Input else {
            return nil
        }
        
        let output = Output()
        
        let createUseCaseInput = BlockCreateUseCase.Input(modelCreate: self.modelCreateEvent)
        let createUseCaseOutput = createUseCase.transform(input: createUseCaseInput,
                                                          disposeBag: disposeBag)
        
        bindCreateSuccess(createUseCaseOutput.isCreateSuccess,
                          to: output.isCreateSuccess,
                          disposeBag)
        bindModelTitle(input.modelTitle, disposeBag)
        bindBlockTime(input.modelBlockTime, disposeBag)
        bindCompleteButtonTapEvent(input.completeButtonTapEvent, disposeBag)
        bindCancelButtonTapEvent(input.cancelButtonTapEvent, disposeBag)
        bindStartEvent(input.startEvent, disposeBag)
        
        return output as? OutputType
    }
}

private extension DefaultBlockCreateViewModel {
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
    
    func bindBlockTime(_ divideCount: Observable<Int>, _ disposeBag: DisposeBag) {
        divideCount
            .subscribe(onNext: { [weak self] blockTime in
                guard let self else { return }
                self.modelBlockTime = blockTime
            }).disposed(by: disposeBag)
    }
    
    func bindCompleteButtonTapEvent(_ completeEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        completeEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                
                let title = self.modelTitle ?? ""
                let blockTime = self.modelBlockTime ?? -1
                let model = BlockModel(id: UUID(), title: title, blockTime: blockTime)
                self.modelCreateEvent.onNext(model)
                self.originModel = model
            }).disposed(by: disposeBag)
    }
    
    func bindCancelButtonTapEvent(_ cancelButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        cancelButtonTapEvent
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.finish(with: nil)
            }).disposed(by: disposeBag)
    }
    
    func bindStartEvent(_ startEvent: Observable<CompleteAlert>, _ disposeBag: DisposeBag) {
        startEvent.subscribe(onNext: { [weak self] completeAlert in
            guard let self,
                  let originModel = self.originModel else { return }
            
            switch completeAlert {
            case .completeWithStart:
                let startUseCase = BlockStartUseCase(originModel: originModel)
                self.coordinator?.finish(with: startUseCase)
            case .completeWithoutStart:
                self.coordinator?.finish(with: nil)
            }
        }).disposed(by: disposeBag)
    }
   
}
