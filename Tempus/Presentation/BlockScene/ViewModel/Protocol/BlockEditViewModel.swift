//
//  BlockEditViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import RxSwift

protocol BlockEditViewModel: AnyObject, ViewModel {
    var coordinator: BlockEditCoordinator? { get set }
}
