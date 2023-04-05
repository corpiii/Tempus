//
//  ModeInfo.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/05.
//

import RxSwift

protocol ModeInfo {
    var type: ModeType { get }
    var remainTime: Observable<Time> { get }
}
