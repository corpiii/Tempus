//
//  BlockStartUseCaseTests.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/10.
//

import XCTest
import RxSwift

class BlockStartUseCaseTests: XCTestCase {
    
    var blockStartUseCase: BlockStartUseCase!
    var disposeBag: DisposeBag!
    var originModel: BlockModel!
    let divideCount: Double = 4
    
    override func setUpWithError() throws {
        originModel = BlockModel(id: UUID(), title: "testTitle", divideCount: divideCount)
        blockStartUseCase = BlockStartUseCase(originModel: originModel)
        disposeBag = DisposeBag()
    }
    
    func test_modeStart() throws {
        // Arrange
        let timeObservable = blockStartUseCase.fetchTimeObservable()
        let expectation = self.expectation(description: "timeObservable onNext called")
        
        let schedule = generateSchedule(divideCount: divideCount)
        
        // Act, Assert
        timeObservable.subscribe(onNext: { time in
            let now = Date().timeIntervalSince1970
            let target = schedule[0].timeIntervalSince1970
            
            XCTAssertEqual(time.totalSecond, Double(Int(target - now)))
            
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        blockStartUseCase.modeStart()
        wait(for: [expectation], timeout: 1.0)
    }
    
    final private func generateSchedule(divideCount: Double) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        let interval = 24 / divideCount
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
