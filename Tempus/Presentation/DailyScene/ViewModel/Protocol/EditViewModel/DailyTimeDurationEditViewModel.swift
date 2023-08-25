//
//  DailyTimeDurationEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import Foundation

protocol DailyTimeDurationEditViewModel: AnyObject, ViewModel {
    var coordinator: DailyTimeDurationEditCoordinator? { get set }
}
