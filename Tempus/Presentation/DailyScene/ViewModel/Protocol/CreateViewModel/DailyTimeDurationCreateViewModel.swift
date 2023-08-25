//
//  DailyTimeDurationCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import RxSwift

protocol DailyTimeDurationCreateViewModel: AnyObject, ViewModel {
    var coordinator: DailyTimeDurationCreateCoordinator? { get set }
}
