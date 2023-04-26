//
//  TimerStartUseCaseTests.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/06.
//

import XCTest

import RxSwift

final class TimerStartUseCaseTests: XCTestCase {
    var timerModel: TimerModel = .init(id: UUID(),
                                       title: "testTitle",
                                       wasteTime: 3.0)
    var timerStartUseCase: TimerStartUseCase!
    var disposeBag: DisposeBag!
    var input: TimerStartUseCase.Input!
    var output: TimerStartUseCase.Output!
    
    var modeStartEvent: PublishSubject<Void> = .init()
    var modeStopEvent: PublishSubject<Void> = .init()
    
    override func setUpWithError() throws {
        timerStartUseCase = TimerStartUseCase(model: timerModel)
        disposeBag = DisposeBag()
        input = .init(modeStartEvent: modeStartEvent, modeStopEvent: modeStopEvent)
        output = timerStartUseCase.transform(input: input, disposeBag: disposeBag)
    }
    
    func test_modeStart() {
        // Arrange
        var expectValues: [Double] = []
        var resultValues: [Double] = []
        let expectation = XCTestExpectation(description: "timer completed")

        for i in stride(from: timerModel.wasteTime, to: 0, by: -0.1) {
            let value = abs(round(i * 10)) / 10
            expectValues.append(value)
        }
        expectValues.append(0.0)

        // Act
        output.remainTime
            .subscribe(onNext: { time in
                resultValues.append(time.totalSecond)
                if time.totalSecond == 0 {
                    expectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        modeStartEvent.onNext(())
        wait(for: [expectation], timeout: timerModel.wasteTime + 1)
        
        // Assert
        XCTAssertEqual(resultValues, expectValues)
    }
}
