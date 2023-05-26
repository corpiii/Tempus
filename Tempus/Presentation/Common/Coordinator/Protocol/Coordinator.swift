//
//  Coordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/26.
//

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
}
