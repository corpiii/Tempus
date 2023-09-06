//
//  BlockCreateCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/08/23.
//

protocol BlockCreateCoordinator: Coordinator, FinishDelegate, AnyObject {
    func finish(with startUseCase: BlockStartUseCase?)
}
