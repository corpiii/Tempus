//
//  DailyStartUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/11.
//

import XCTest

import RxSwift

final class DailyStartUseCaseTest: XCTestCase {
    let originModel = DailyModel(id: UUID(),
                                 title: "testTitle",
                                 startTime: 12.0 * 60.0 * 60,
                                 repeatCount: 4,
                                 focusTime: 1.5 * 60 * 60,
                                 breakTime: 0.5 * 60 * 60)
    
    var dailyStartUseCase: DailyStartUseCase!
    var input: DailyStartUseCase.Input!
    var modeStartEvent: PublishSubject<Void> = .init()
    var modeStopEvent: PublishSubject<Void> = .init()
    var output: DailyStartUseCase.Output!
    var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        dailyStartUseCase = DailyStartUseCase(originModel: originModel)
        input = DailyStartUseCase.Input(modeStartEvent: modeStartEvent,
                                        modeStopEvent: modeStopEvent)
        output = dailyStartUseCase.bind(to: input)
    }
    
    func test_modeStart() {
        // Arrange
        let expectation = self.expectation(description: "Time observable emits values")
        let schedule = generateSchedule(originModel)
        
        // Act, Assert
        output.remainTime
            .subscribe(onNext: { remainTime in
                let now = Date().timeIntervalSince1970
                let target = schedule[0].timeIntervalSince1970
                
                XCTAssertEqual(remainTime.totalSecond, Double(Int(target - now)))
                expectation.fulfill()
        }).disposed(by: disposeBag)

        modeStartEvent.onNext(())
        wait(for: [expectation], timeout: 1.0)
    }

    final private func generateSchedule(_ originModel: DailyModel) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        
        var startTime = calendar.startOfDay(for: now).addingTimeInterval(originModel.startTime)
        let repeatCount = originModel.repeatCount
        let focusTime = originModel.focusTime
        let breakTime = originModel.breakTime
        
        let oneIntervalSecond = focusTime + breakTime
        let oneDaySecond = 24.0 * 60.0 * 60.0
        
        var schedule: [Date] = []
        schedule.append(startTime)
        
        (1...repeatCount).forEach({ _ in
            schedule.append(startTime.addingTimeInterval(focusTime))
            schedule.append(startTime.addingTimeInterval(focusTime + breakTime))
            startTime = startTime.addingTimeInterval(oneIntervalSecond)
        })
        
        while schedule.first! < now {
            let lastDate = schedule.removeFirst()
            let newDate = lastDate.addingTimeInterval(oneDaySecond)
            schedule.append(newDate)
        }
        
        return schedule
    }
}
