//
//  DailyInfoCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import Foundation

protocol DailyInfoCreateViewModel: AnyObject, ViewModel {
    var coordinator: DailyInfoCreateCoordinator? { get set }
}
