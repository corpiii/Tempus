//
//  ClockViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/24.
//

import RxSwift

protocol ClockViewModel: AnyObject, StartModeDelegate, ViewModel {
    var modeStartUseCase: ModeStartUseCase? { get set }
    var coordinator: ClockCoordinator? { get set }
}
