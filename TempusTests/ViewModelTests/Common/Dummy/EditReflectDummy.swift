//
//  EditReflectDummy.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/03.
//

final class EditReflectDummy: EditReflectDelegate {
    func reflect(_ model: Model) {
        #if DEBUG
        print("EditReflectMock: reflect(_ model: Mode) called")
        #endif
    }
}
