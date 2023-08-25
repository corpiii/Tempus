//
//  BlockDetailViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/25.
//

import RxSwift

protocol BlockDetailViewModel: AnyObject, EditReflectDelegate {
    var coordinator: BlockDetailCoordinator? { get set }
    
    func transform<InputType, OutputType>(input: InputType, disposeBag: DisposeBag) -> OutputType?
}
