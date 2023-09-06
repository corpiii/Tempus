//
//  BlockDetailViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import RxSwift

protocol BlockDetailViewModel: AnyObject, EditReflectDelegate, ViewModel {
    var coordinator: BlockDetailCoordinator? { get set }
}
