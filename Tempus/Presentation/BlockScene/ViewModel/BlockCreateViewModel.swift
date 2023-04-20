//
//  BlockCreateViewModel.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/20.
//

import RxSwift

final class BlockCreateViewModel {
    struct Input {
        let completeEvent: Observable<CompleteAlert>
        let modelTitle: Observable<String>
        let divideCount: Observable<Int>
    }
}
