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
        let completeButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let isEditSuccess: PublishSubject<Bool>
    }
    
    private var originModel: BlockModel
    private var modelTitle: String?
    private var modelDivideCount: Int?
    private let blockEditUseCase: BlockEditUseCase
    private let completeButtonTapEvent: PublishSubject<BlockModel> = .init()
    
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    private weak var editReflectDelegate: EditReflectDelegate?
    
    init(originModel: BlockModel,
         repository: DataManagerRepository,
         fetchRefreshDelegate: FetchRefreshDelegate,
         editReflectDelegate: EditReflectDelegate) {
        self.originModel = originModel
        self.blockEditUseCase = .init(repository: repository)
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.editReflectDelegate = editReflectDelegate
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let editUseCaseInput = BlockEditUseCase.Input(modelEditEvent: self.completeButtonTapEvent)
        let editUseCaseOutput = blockEditUseCase.transform(input: editUseCaseInput,
                                                           disposeBag: disposeBag)
        let output = Output(isEditSuccess: editUseCaseOutput.isEditSuccess)
        
        bindModelTitle(input.modelTitle, disposeBag)
        bindDivideCount(input.modelDivideCount, disposeBag)
        bindCompleteEvent(input.completeButtonTapEvent, disposeBag)
        bindEditSuccess(editUseCaseOutput.isEditSuccess, disposeBag)
        
        return output
    }
}

private extension BlockEditViewModel {
    func bindModelTitle(_ modelTitle: Observable<String>, _ disposeBag: DisposeBag) {
        modelTitle
            .subscribe(onNext: { [weak self] modelTitle in
                guard let self else { return }
                self.modelTitle = modelTitle
            }).disposed(by: disposeBag)
    }
    
    func bindDivideCount(_ divideCount: Observable<Int>, _ disposeBag: DisposeBag) {
        divideCount
            .subscribe(onNext: { [weak self] modelDivideCount in
                guard let self else { return }
                self.modelDivideCount = modelDivideCount
            }).disposed(by: disposeBag)
    }
    
    func bindCompleteEvent(_ completeEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        completeEvent
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                if let modelTitle = self.modelTitle {
                    self.originModel.title = modelTitle
                }
                
                if let modelDivideCount = self.modelDivideCount {
                    self.originModel.divideCount = modelDivideCount
                }
                
                self.completeButtonTapEvent.onNext(self.originModel)
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
