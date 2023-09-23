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
    
    var backButtonTapEvent: PublishSubject<Void>!
    var nextButtonTapEvent: PublishSubject<Void>!
    var modelTitle: PublishSubject<String>!
    var modelFocusTime: PublishSubject<Date>!
    var modelBreakTime: PublishSubject<Date>!
    
    var dailyInfoEditViewModelInput: DefaultDailyInfoEditViewModel.Input!
    var dailyInfoEditViewModelOutput: DefaultDailyInfoEditViewModel.Output!
    
    override func setUpWithError() throws {
        disposeBag = .init()
        originModel = .init(id: UUID(),
                            title: "testTitle",
                            startTime: 13.0 * 60 * 60,
                            repeatCount: 4,
                            focusTime: 0,
                            breakTime: 0)
        
        dailyInfoEditViewModel = DefaultDailyInfoEditViewModel(originModel: originModel)
        
        backButtonTapEvent = .init()
        nextButtonTapEvent = .init()
        modelTitle = .init()
        modelFocusTime = .init()
        modelBreakTime = .init()
        
        dailyInfoEditViewModelInput = .init(backButtonTapEvent: backButtonTapEvent,
                                            nextButtonTapEvent: nextButtonTapEvent,
                                            modelTitle: modelTitle,
                                            modelFocusTime: modelFocusTime,
                                            modelBreakTime: modelBreakTime)
        dailyInfoEditViewModelOutput = dailyInfoEditViewModel.transform(input: dailyInfoEditViewModelInput,
                                                                        disposeBag: disposeBag)
    }

    func test_isFillAllInfo_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "isFillAllInfo_is_success")
        let startToday = Calendar(identifier: .gregorian).startOfDay(for: Date())
        
        let testModelTitle = "changeTitle"
        let testFocusTime = Date(timeInterval: 3 * 60 * 60, since: startToday)
        let testBreakTime = Date(timeInterval: 30 * 60, since: startToday)
        var result: Bool = false
        
        // Act
        dailyInfoEditViewModelOutput.isFillAllInfo
            .subscribe(onNext: { isFillAllInfo in
                result = isFillAllInfo
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        modelTitle.onNext(testModelTitle)
        modelFocusTime.onNext(testFocusTime)
        modelBreakTime.onNext(testBreakTime)
        nextButtonTapEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(result)
    }
}
