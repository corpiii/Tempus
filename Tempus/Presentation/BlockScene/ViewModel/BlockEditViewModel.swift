//
//  BlockEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/26.
//

import Foundation

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
        let editUSeCaseOutput = blockEditUseCase.transform(input: editUseCaseInput,
                                                           disposeBag: disposeBag)
        let output = Output(isEditSuccess: editUSeCaseOutput.isEditSuccess)
        
        bind(input: input, disposeBag: disposeBag)
        
        editUSeCaseOutput.isEditSuccess
            .subscribe(onNext: { [weak self] isSuccess in
                guard let self else { return }
                if isSuccess {
                    self.fetchRefreshDelegate?.refresh()
                    self.editReflectDelegate?.reflect(self.originModel)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
}

private extension BlockEditViewModel {
    func bind(input: Input, disposeBag: DisposeBag) {
        input.modelTitle
            .subscribe(onNext: { [weak self] modelTitle in
                guard let self else { return }
                self.modelTitle = modelTitle
            }).disposed(by: disposeBag)
        
        input.modelDivideCount
            .subscribe(onNext: { [weak self] modelDivideCount in
                guard let self else { return }
                self.modelDivideCount = modelDivideCount
            }).disposed(by: disposeBag)
        
        input.completeButtonTapEvent
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
}
