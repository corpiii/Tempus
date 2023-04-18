//
//  DailyFetchUseCaseTests.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/18.
//

import XCTest

final class DailyFetchUseCaseTests: XCTestCase {
    var dailyCreateUseCase: DailyCreateUseCase!
    var dailyFetchUseCase: DailyFetchUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        dailyCreateUseCase = DailyCreateUseCase(repository: coreDataRepositoryMock)
        dailyFetchUseCase = DailyFetchUseCase(repository: coreDataRepositoryMock)
    }
    
    func test_Daily_fetch_is_success() {
        // Arrange
        let id = UUID()
        let title = "testTitle"
        let startTime: Double = 123456
        let repeatCount: Int = 4
        let focusTime: Double = 123456789
        let breakTime: Double = 123456789
        let model = DailyModel(id: id,
                               title: title,
                               startTime: startTime,
                               repeatCount: repeatCount,
                               focusTime: focusTime,
                               breakTime: breakTime)
        
        try! dailyCreateUseCase.execute(model: model) {}
        
        // Act, Assert
        do {
            try dailyFetchUseCase.execute { models in
                XCTAssertEqual(models.first!.id, id)
            }
        } catch {
            XCTFail()
        }
    }
}
