//
//  DailyTimeDurationViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/06.
//

import Foundation

import RxSwift

final class DailyTimeDurationViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private let editUseCase: DailyEditUseCase
    private var originModel: DailyModel
    private weak var fetchRefreshDelegate: FetchRefreshDelegate?
    private weak var editReflectDelegate: EditReflectDelegate?
    
    init(originModel: DailyModel,
         repository: DataManagerRepository,
         fetchRefreshDelegate: FetchRefreshDelegate,
         editReflectDelegate: EditReflectDelegate) {
        self.originModel = originModel
        self.editUseCase = .init(repository: repository)
        self.fetchRefreshDelegate = fetchRefreshDelegate
        self.editReflectDelegate = editReflectDelegate
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        return output
    }
}

