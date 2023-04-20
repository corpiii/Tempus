//
//  BlockCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/20.
//

import Foundation

import RxSwift

final class BlockCreateViewModel {
    struct Input {
        let completeEvent: Observable<CompleteAlert>
        let modelTitle: Observable<String>
        let divideCount: Observable<Int>
        
        let modelFetchEvent: PublishSubject<Void>
    }
    
    struct Output {
        let completeFail: PublishSubject<Void>
    }
    
    private var modelTitle: String?
    private var divideCount: Int?
    private let completeFail: PublishSubject<Void> = .init()

    private var createUseCase: BlockCreateUseCase
    private var startUseCase: BlockStartUseCase
    
    init(repository: DataManagerRepository, startUseCase: BlockStartUseCase) {
        self.createUseCase = .init(repository: repository)
        self.startUseCase = startUseCase
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(completeFail: completeFail)
        
        bind(input, disposeBag, completeFail)
        
        return output
    }
    
    private func bind(_ input: Input, _ disposeBag: DisposeBag, _ completeFail: PublishSubject<Void>) {
        input.completeEvent
            .subscribe(onNext: { [weak self] completeAlert in
                guard let self = self,
                      let modelTitle = self.modelTitle,
                      let divideCount = self.divideCount else {
                    return completeFail.onNext(())
                }
                
                let model = BlockModel(id: UUID(), title: modelTitle, divideCount: divideCount)
                
                do {
                    try self.createUseCase.execute(model: model, {
                        input.modelFetchEvent.onNext(())
                    })
                } catch {
                    return completeFail.onNext(())
                }
                
                switch completeAlert {
                case .completeWithStart:
                    // coordinator push
                    return
                case .completeWithoutStart:
                    // coordinator push
                    return
                }
            }).disposed(by: disposeBag)
    }
}
