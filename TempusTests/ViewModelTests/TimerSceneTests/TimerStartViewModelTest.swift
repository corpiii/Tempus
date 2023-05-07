//
//  TimerStartViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/05/07.
//

import XCTest

import RxSwift

final class TimerStartViewModelTest: XCTestCase {
    var timerStartViewModel: TimerStartViewModel!
    var disposeBag: DisposeBag!
    
    var modelWasteTime: PublishSubject<Double>!
    var startButtonTapEvent: PublishSubject<Void>!
    
    var input: TimerStartViewModel.Input!
    var output: TimerStartViewModel.Output!
    
    override func setUpWithError() throws {
        timerStartViewModel = .init()
        disposeBag = .init()
        
        modelWasteTime = .init()
        startButtonTapEvent = .init()
        
        input = .init(modelWasteTime: modelWasteTime, startButtonTapEvent: startButtonTapEvent)
        output = timerStartViewModel.transform(input: input, disposeBag: disposeBag)
    }
    
    func test_start_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "start_is_success")
        let testWasteTime = 3.0 * 60 * 60
        var result = false
        
        // Act
        output.isStartSuccess
            .subscribe(onNext: { isStartSuccess in
                print("??")
                result = isStartSuccess
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        modelWasteTime.onNext(testWasteTime)
        startButtonTapEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(result)
    }

}
