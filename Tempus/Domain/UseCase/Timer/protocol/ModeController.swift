//
//  ModeController.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/04.
//

protocol ModeController {
    typealias Input = ClockStartUseCase.Input
    typealias Output = ClockStartUseCase.Output
    
    func bind(to input: Input) -> Output
}
