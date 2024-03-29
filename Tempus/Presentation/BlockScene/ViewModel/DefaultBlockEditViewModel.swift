//
//  DefaultBlockEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/26.
//

import RxSwift

final class DefaultBlockEditViewModel: BlockEditViewModel {
    struct Input {
        let modelTitle: Observable<String>
        let modelBlockTime: Observable<Int>
        let doneButtonTapEvent: Observable<Void>
        let backButtonTapEvent: Observable<Void>
        let completeEvent: Observable<Void>
    }
    
    struct Output {
        let title: String
        let blockTime: Int
        let isEditSuccess: PublishSubject<Bool>
    }
    
    private var originModel: BlockModel
    private let blockEditUseCase: BlockEditUseCase
    private let doneButtonTapEvent: PublishSubject<BlockModel> = .init()
    
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    private weak var editReflectDelegate: EditReflectDelegate?
    weak var coordinator: BlockEditCoordinator?
    
    init(originModel: BlockModel,
         repository: DataManagerRepository,
         fetchRefreshDelegate: FetchRefreshDelegate?,
         editReflectDelegate: EditReflectDelegate) {
        self.originModel = originModel
        
        self.blockEditUseCase = .init(repository: repository)
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.editReflectDelegate = editReflectDelegate
    }
    
    func transform<InputType, OutputType>(input: InputType, disposeBag: DisposeBag) -> OutputType? {
        guard let input = input as? Input else {
            return nil
        }
        
        let editUseCaseInput = BlockEditUseCase.Input(modelEditEvent: self.doneButtonTapEvent)
        let editUseCaseOutput = blockEditUseCase.transform(input: editUseCaseInput,
                                                           disposeBag: disposeBag)
        let output = Output(title: originModel.title,
                            blockTime: originModel.blockTime,
                            isEditSuccess: editUseCaseOutput.isEditSuccess)
        
        bindModelTitle(input.modelTitle, disposeBag)
        bindBlockTime(input.modelBlockTime, disposeBag)
        bindDoneButtonTapEvent(input.doneButtonTapEvent, disposeBag)
        bindBackButtonTapEvent(input.backButtonTapEvent, disposeBag)
        bindCompleteEvent(input.completeEvent, disposeBag)
        bindEditSuccess(editUseCaseOutput.isEditSuccess, disposeBag)
        
        return output as? OutputType
    }
}

private extension DefaultBlockEditViewModel {
    func bindModelTitle(_ modelTitle: Observable<String>, _ disposeBag: DisposeBag) {
        modelTitle
            .subscribe(onNext: { [weak self] modelTitle in
                guard let self else { return }
                self.originModel.title = modelTitle
            }).disposed(by: disposeBag)
    }
    
    func bindBlockTime(_ divideCount: Observable<Int>, _ disposeBag: DisposeBag) {
        divideCount
            .subscribe(onNext: { [weak self] blockTime in
                guard let self else { return }
                self.originModel.blockTime = blockTime
            }).disposed(by: disposeBag)
    }
    
    func bindDoneButtonTapEvent(_ doneButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        doneButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.doneButtonTapEvent.onNext(self.originModel)
            }).disposed(by: disposeBag)
    }
    
    func bindBackButtonTapEvent(_ backButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        backButtonTapEvent
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            }).disposed(by: disposeBag)
    }
    
    func bindCompleteEvent(_ completeEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        completeEvent
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            }).disposed(by: disposeBag)
    }
    
    func bindEditSuccess(_ isEditSuccess: PublishSubject<Bool>, _ disposeBag: DisposeBag) {
        isEditSuccess
            .subscribe(onNext: { [weak self] isSuccess in
                guard let self else { return }
                if isSuccess {
                    self.fetchRefreshDelegate?.refresh()
                    self.editReflectDelegate?.reflect(self.originModel)
                }
            }).disposed(by: disposeBag)
    }
}
