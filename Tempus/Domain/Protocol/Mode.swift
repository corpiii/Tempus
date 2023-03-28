//
//  Mode.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/28.
//

import Foundation

protocol Mode {
    var type: ModeType { get }
    
    func modeStart()
    func modeStop()
}
