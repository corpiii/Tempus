//
//  StartModeDelegate.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/29.
//

protocol StartModeDelegate: AnyObject {
    func startWith(_ startUseCase: ModeStartUseCase)
}
