//
//  DailyInfoCreateViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/02.
//

import XCTest

import RxSwift

final class DailyInfoCreateViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    
    var modelTitle: PublishSubject<String>!
    var modelFocusTime: PublishSubject<Date>!
    var modelBreakTime: PublishSubject<Date>!
    var nextButtonTapEvent: PublishSubject<Void>!
    
    var dailyInfoCreateViewModel: DailyInfoCreateViewModel!
    var dailyInfoCreateViewModelInput: DefaultDailyInfoCreateViewModel.Input!
    var dailyInfoCreateViewModelOutput: DefaultDailyInfoCreateViewModel.Output!

    override func setUpWithError() throws {
        disposeBag = .init()
        
        modelTitle = .init()
        modelFocusTime = .init()
        modelBreakTime = .init()
        nextButtonTapEvent = .init()
        
        dailyInfoCreateViewModel = DefaultDailyInfoCreateViewModel()
        dailyInfoCreateViewModelInput = .init(cancelButtonTapEvent: PublishSubject<Void>(),
                                              nextButtonTapEvent: nextButtonTapEvent,
                                              modelTitle: modelTitle,
                                              modelFocusTime: modelFocusTime,
                                              modelBreakTime: modelBreakTime)
        dailyInfoCreateViewModelOutput = dailyInfoCreateViewModel.transform(input: dailyInfoCreateViewModelInput,
                                                                            disposeBag: disposeBag)
    }
    
    func test_isFillAllInfo_is_true() {
        // Arrange
        let startToday = Calendar(identifier: .gregorian).startOfDay(for: Date())
        
        let expectation = XCTestExpectation(description: "isFillAllInfo_is_true")
        let testTitle = "testTitle"
        let testFocusTime = Date(timeInterval: 3 * 60 * 60, since: startToday)
        let testBreakTime = Date(timeInterval: 30 * 60, since: startToday)
        var resultValue = false
        
        // Act
        dailyInfoCreateViewModelOutput.isFillAllInfo
            .subscribe(onNext: { isFillAllInfo in
                print(isFillAllInfo)
                resultValue = isFillAllInfo
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        modelTitle.onNext(testTitle)
        modelFocusTime.onNext(testFocusTime)
        modelBreakTime.onNext(testBreakTime)
        nextButtonTapEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(resultValue)
    }
}
