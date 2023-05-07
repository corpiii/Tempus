//
//  DailyInfoEditViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/07.
//

import XCTest

import RxSwift

final class DailyInfoEditViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var originModel: DailyModel!
    var dailyInfoEditViewModel: DailyInfoEditViewModel!
    
    var nextButtonTapEvent: PublishSubject<Void>!
    var modelTitle: PublishSubject<String>!
    var modelFocusTime: PublishSubject<Double>!
    var modelBreakTime: PublishSubject<Double>!
    
    var input: DailyInfoEditViewModel.Input!
    var output: DailyInfoEditViewModel.Output!
    
    override func setUpWithError() throws {
        disposeBag = .init()
        originModel = .init(id: UUID(),
                            title: "testTitle",
                            startTime: 13.0 * 60 * 60,
                            repeatCount: 4,
                            focusTime: 1.5 * 60 * 60,
                            breakTime: 0.5 * 60 * 60)
        
        dailyInfoEditViewModel = .init(originModel: originModel)
        
        nextButtonTapEvent = .init()
        modelTitle = .init()
        modelFocusTime = .init()
        modelBreakTime = .init()
        
        input = .init(nextButtonTapEvent: nextButtonTapEvent,
                      cancelButtonTapEvent: PublishSubject<Void>(),
                      modelTitle: modelTitle,
                      modelFocusTime: modelFocusTime,
                      modelBreakTime: modelBreakTime)
        output = dailyInfoEditViewModel.transform(input: input, disposeBag: disposeBag)
    }

    func test_isFillAllInfo_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "isFillAllInfo_is_success")
        let testModelTitle = "changeTitle"
        let testModelFocusTime = 3.0 * 60 * 60
        let testModelBreakTime = 1.0 * 60 * 60
        var result: Bool = false
        
        // Act
        output.isFillAllInfo
            .subscribe(onNext: { isFillAllInfo in
                result = isFillAllInfo
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        modelTitle.onNext(testModelTitle)
        modelFocusTime.onNext(testModelFocusTime)
        modelBreakTime.onNext(testModelBreakTime)
        nextButtonTapEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(result)
    }
}
