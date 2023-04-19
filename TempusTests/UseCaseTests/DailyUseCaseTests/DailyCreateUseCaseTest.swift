//
//  DailyCreateUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/01.
//

import XCTest

final class DailyCreateUseCaseTest: XCTestCase {
    var dailyCreateUseCase: DailyCreateUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        dailyCreateUseCase = DailyCreateUseCase(repository: coreDataRepositoryMock)
    }

    func test_Daily_create_is_success() {
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
        
        // Act, Assert
        do {
            try dailyCreateUseCase.execute(model: model) {}
            XCTAssertEqual(coreDataRepositoryMock.dailyModel!.id, id)
        } catch {
            XCTFail()
        }
    }
}
