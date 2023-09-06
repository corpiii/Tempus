//
//  DailyDetailViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import RxSwift

protocol DailyDetailViewModel: AnyObject, ViewModel, EditReflectDelegate {
    var coordinator: DailyDetailCoordinator?  { get set }
}
