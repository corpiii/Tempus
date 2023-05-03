//
//  ModeManageError.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/14.
//

import Foundation

enum ModeManageError: Error {
    case modeNotExist
}

extension ModeManageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .modeNotExist:
            return "모드가 설정되지 않았습니다."
        }
    }
}
