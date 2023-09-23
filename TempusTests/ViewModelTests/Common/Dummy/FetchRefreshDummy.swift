//
//  FetchRefreshDummy.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/03.
//

final class FetchRefreshDummy: FetchRefreshDelegate {
    func refresh() {
        #if DEBUG
        print("FetchRefreshDelegateMock: refresh() called")
        #endif
    }
}
