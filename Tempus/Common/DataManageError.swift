//
//  DataManageError.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/29.
//

import Foundation

enum DataManageError: Error {
    case createFailure
    case fetchFailure
    case updateFailure
    case deleteFailure
}

extension DataManageError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .createFailure:
                return "생성에 실패했습니다."
            case .fetchFailure:
                return "가져오기에 실패했습니다."
            case .updateFailure:
                return "업데이트에 실패했습니다."
            case .deleteFailure:
                return "삭제에 실패했습니다."
        }
    }
}
