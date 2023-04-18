//
//  BlockStartUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/10.
//

import XCTest
import RxSwift

class BlockStartUseCaseTests: XCTestCase {
    var originModel: BlockModel = BlockModel(id: UUID(),
                                             title: "testTitle",
                                             divideCount: 4)
    var blockStartUseCase: BlockStartUseCase!
    var input: BlockStartUseCase.Input!
    var modeStartEvent: PublishSubject<Void> = .init()
    var modeStopEvent: PublishSubject<Void> = .init()
    var output: BlockStartUseCase.Output!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        blockStartUseCase = BlockStartUseCase(originModel: originModel)
        input = BlockStartUseCase.Input(modeStartEvent: modeStartEvent,
                                        modeStopEvent: modeStopEvent)
        output = blockStartUseCase.bind(to: input)
        disposeBag = DisposeBag()
    }
    
    func test_modeStart() throws {
        // Arrange
        let expectation = self.expectation(description: "timeObservable onNext called")
        let schedule = generateSchedule(divideCount: originModel.divideCount)

        // Act, Assert
        output.remainTime
            .subscribe(onNext: { time in
                let now = Date().timeIntervalSince1970
                let target = schedule[0].timeIntervalSince1970
                
                XCTAssertEqual(time.totalSecond, Double(Int(target - now)))
                
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        modeStartEvent.onNext(())
        wait(for: [expectation], timeout: 1.0)
    }
    
    final private func generateSchedule(divideCount: Int) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        let interval = Double(24 / divideCount)
        let oneDaySecond = 24.0 * 60.0 * 60.0
        let oneHourSecond = 60.0 * 60.0
        
        var schedule: [Date] = []
        var date = calendar.startOfDay(for: now)
        let lastDate = date.addingTimeInterval(oneDaySecond)
        
        while date < lastDate {
            schedule.append(date)
            date = date.addingTimeInterval(interval * oneHourSecond)
        }
        
        while schedule.first! < now {
            let lastDate = schedule.removeFirst()
            let newDate = lastDate.addingTimeInterval(oneDaySecond)
            schedule.append(newDate)
        }
        
        return schedule
    }
}
