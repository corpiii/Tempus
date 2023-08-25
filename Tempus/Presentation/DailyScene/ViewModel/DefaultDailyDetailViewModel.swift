//
//  DefaultDailyDetailViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/04.
//

import RxSwift

final class DefaultDailyDetailViewModel: DailyDetailViewModel {
    struct Input {
        let startButtonTapEvent: Observable<Void>
        let editButtonTapEvent: Observable<Void>
        let backButtonTapEvent: Observable<Void>
    }
    
    struct Output {
        let originModelSubject: BehaviorSubject<DailyModel>
    }
    
    private let originModelSubject: BehaviorSubject<DailyModel>
    weak var coordinator: DailyDetailCoordinator?
    
    init(originModel: DailyModel) {
        self.originModelSubject = .init(value: originModel)
    }
    
    func transform<InputType, OutputType>(input: InputType, disposeBag: RxSwift.DisposeBag) -> OutputType? {
        guard let input = input as? Input else {
            return nil
        }
        
        let output = Output(originModelSubject: originModelSubject)
        
        bindBackButtonTapEvent(input.backButtonTapEvent, disposeBag)
        bindEditButtonTapEvent(input.editButtonTapEvent, disposeBag)
        bindStartButtonTapEvent(input.startButtonTapEvent, disposeBag)
        
        return output as? OutputType
    }
}

private extension DefaultDailyDetailViewModel {
    func bindStartButtonTapEvent(_ startEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        startEvent
            .subscribe(onNext: { [weak self] in
                guard let self,
                      let originModel = try? self.originModelSubject.value() else { return }
                
                let startUseCase = DailyStartUseCase(originModel: originModel)
                self.coordinator?.finish(with: startUseCase)
            }).disposed(by: disposeBag)
    }
    
    func bindEditButtonTapEvent(_ editEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        editEvent
            .subscribe(onNext: { [weak self] in
                guard let originModel = try? self?.originModelSubject.value() else {
                    return
                }
                
                self?.coordinator?.pushDailyInfoEditViewController(originModel: originModel)
            }).disposed(by: disposeBag)
    }
    
    func bindBackButtonTapEvent(_ backButtonTapEvent: Observable<Void>, _ disposeBag: DisposeBag) {
        backButtonTapEvent
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish(with: nil)
            }).disposed(by: disposeBag)
    }
}

extension DefaultDailyDetailViewModel {
    func reflect(_ model: Model) {
        if let model = model as? DailyModel {
            self.originModelSubject.onNext(model)
        }
    }
}

