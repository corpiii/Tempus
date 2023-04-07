//
//  TimerStartUseCaseTests.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/06.
//

import XCTest

import RxSwift

final class TimerStartUseCaseTests: XCTestCase {
    var timerModel: TimerModel!
    var timerStartUseCase: TimerStartUseCase!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        let id = UUID()
        let title = "testTitle"
        let wasteTime = Double(3)
        
        timerModel = TimerModel(id: id, title: title, wasteTime: wasteTime)
        timerStartUseCase = TimerStartUseCase(model: timerModel)
        disposeBag = DisposeBag()
    }
    
    func test_timer_working_valid() {
        // Arrange
        let timeObservable = timerStartUseCase.fetchTimeObservable()

        var expectValues: [Double] = []
        var resultValues: [Double] = []
        let expectation = XCTestExpectation(description: "timer completed")

        for i in stride(from: timerModel.wasteTime, to: 0, by: -0.1) {
            let value = abs(round(i * 10)) / 10
            expectValues.append(value)
        }
        expectValues.append(0.0)

        // Act
        timeObservable.subscribe(onNext: { time in
            if time.totalSecond < 0 {
                expectation.fulfill()
            } else {
                resultValues.append(time.totalSecond)
            }
        }).disposed(by: disposeBag)

        self.timerStartUseCase.modeStart()

        wait(for: [expectation], timeout: timerModel.wasteTime + 1)
        
        // Assert
        XCTAssertEqual(resultValues, expectValues)

    }

}
