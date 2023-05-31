//
//  BlockEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/26.
//

import RxSwift

final class BlockEditViewModel {
    struct Input {
        let modelTitle: Observable<String>
        let modelDivideCount: Observable<Int>
        let doneButtonTapEvent: Observable<Void>
        let finishEvent: Observable<Void>
    }
    
    struct Output {
        let title: String
        let divideCount: Int
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
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let editUseCaseInput = BlockEditUseCase.Input(modelEditEvent: self.doneButtonTapEvent)
        let editUseCaseOutput = blockEditUseCase.transform(input: editUseCaseInput,
                                                           disposeBag: disposeBag)
        let output = Output(title: originModel.title,
                            divideCount: originModel.divideCount,
                            isEditSuccess: editUseCaseOutput.isEditSuccess)
        
        bindModelTitle(input.modelTitle, disposeBag)
        bindDivideCount(input.modelDivideCount, disposeBag)
        bindDoneButtonTapEvent(input.doneButtonTapEvent, disposeBag)
        bindFinishEvent(input.finishEvent, disposeBag)
        bindEditSuccess(editUseCaseOutput.isEditSuccess, disposeBag)
        
        return output
    }
}

private extension BlockEditViewModel {
    func bindModelTitle(_ modelTitle: Observable<String>, _ disposeBag: DisposeBag) {
        modelTitle
            .subscribe(onNext: { [weak self] modelTitle in
                guard let self else { return }
                self.originModel.title = modelTitle
            }).disposed(by: disposeBag)
    }
    
    func bindDivideCount(_ divideCount: Observable<Int>, _ disposeBag: DisposeBag) {
        divideCount
            .subscribe(onNext: { [weak self] modelDivideCount in
                guard let self else { return }
                self.originModel.divideCount = modelDivideCount
            }).disposed(by: disposeBag)
    }
    
    func bindDoneButtonTapEvent(_ doneButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        doneButtonTapEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.doneButtonTapEvent.onNext(self.originModel)
                dump(self.originModel)
            }).disposed(by: disposeBag)
    }
    
    func bindFinishEvent(_ finishEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        finishEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.coordinator?.finish()
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
