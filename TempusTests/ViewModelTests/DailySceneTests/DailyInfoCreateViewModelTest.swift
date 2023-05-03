//
//  DailyInfoCreateViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/02.
//

import XCTest

import RxSwift

final class DailyInfoCreateViewModelTest: XCTestCase {
    var dailyInfoCreateViewModel: DailyInfoCreateViewModel!
    var disposeBag: DisposeBag!
    
    var modelTitle: PublishSubject<String>!
    var modelFocusTime: PublishSubject<Double>!
    var modelBreakTime: PublishSubject<Double>!
    var nextButtonTapEvent: PublishSubject<Void>!
    
    var dailyInfoCreateViewModelInput: DailyInfoCreateViewModel.Input!
    var dailyInfoCreateViewModelOutput: DailyInfoCreateViewModel.Output!

    
    override func setUpWithError() throws {
        dailyInfoCreateViewModel = .init()
        disposeBag = .init()
        
        modelTitle = .init()
        modelFocusTime = .init()
        modelBreakTime = .init()
        nextButtonTapEvent = .init()
        
        dailyInfoCreateViewModelInput = DailyInfoCreateViewModel.Input(cancelButtonEvent: PublishSubject<Void>(),
                                                                       nextButtonEvent: nextButtonTapEvent,
                                                                       modelTitle: modelTitle,
                                                                       modelFocusTime: modelFocusTime,
                                                                       modelBreakTime: modelBreakTime)
        dailyInfoCreateViewModelOutput = dailyInfoCreateViewModel.transform(input: dailyInfoCreateViewModelInput,
                                                                            disposeBag: disposeBag)
    }
    
    func test_isFillAllInfo_is_true() {
        // Arrange
        let expectation = XCTestExpectation(description: "isFillAllInfo_is_true")
        let testTitle = "testTitle"
        let testFocusTime = 1300.0
        let testBreakTime = 300.0
        var resultValue = false
        
        dailyInfoCreateViewModelOutput.isFillAllInfo
            .subscribe(onNext: { isFillAllInfo in
                print(isFillAllInfo)
                resultValue = isFillAllInfo
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        // Act
        modelTitle.onNext(testTitle)
        modelFocusTime.onNext(testFocusTime)
        modelBreakTime.onNext(testBreakTime)
        nextButtonTapEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(resultValue)
    }
}
