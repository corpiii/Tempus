//
//  ClockCoordinator.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/26.
//

import UIKit

class ClockCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
