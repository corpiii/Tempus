//
//  TimerViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import RxSwift

protocol TimerViewModel: AnyObject {
    var coordinator: TimerCoordinator? { get set }
    
    func bind<InputType>(input: InputType, disposeBag: DisposeBag)
}
