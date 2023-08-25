//
//  ClockViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/24.
//

import RxSwift

protocol ClockViewModel: AnyObject, StartModeDelegate {
    var modeStartUseCase: ModeStartUseCase? { get set }
    var coordinator: ClockCoordinator? { get set }
    
    func transform<InputType, OutputType>(input: InputType, disposeBag: DisposeBag) -> OutputType?
}
