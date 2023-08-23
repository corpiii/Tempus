//
//  BlockDetailCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/23.
//

protocol BlockDetailCoordinator: Coordinator, FinishDelegate {
    func finish(with startUseCase: BlockStartUseCase?)
    func pushBlockEditViewController(with originModel: BlockModel)
}
