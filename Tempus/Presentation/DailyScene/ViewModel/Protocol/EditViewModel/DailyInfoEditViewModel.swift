//
//  DailyInfoEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import RxSwift

protocol DailyInfoEditViewModel: AnyObject, ViewModel {
    var coordinator: DailyInfoEditCoordinator? { get set }
}
