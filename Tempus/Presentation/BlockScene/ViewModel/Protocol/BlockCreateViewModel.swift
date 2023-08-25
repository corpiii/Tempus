//
//  BlockCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import RxSwift

protocol BlockCreateViewModel: AnyObject, ViewModel {
    var coordinator: BlockCreateCoordinator? { get set }
}
