//
//  DailyEditUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/01.
//

import XCTest

final class DailyEditUseCaseTest: XCTestCase {
    var dailyCreateUseCase: DailyCreateUseCase!
    var dailyEditUseCase: DailyEditUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        dailyEditUseCase = DailyEditUseCase(repository: coreDataRepositoryMock)
        dailyCreateUseCase = DailyCreateUseCase(repository: coreDataRepositoryMock)
    }

    func test_Daily_edit_is_success() {
        // Arrange
        let id = UUID()
        let title = "testTitle"
        let changeTitle = "changeTitle"
        let startTime: Double = 123456
        let repeatCount: Int = 4
        let focusTime: Double = 123456789
        let breakTime: Double = 123456789
        var model = DailyModel(id: id,
                               title: title,
                               startTime: startTime,
                               repeatCount: repeatCount,
                               focusTime: focusTime,
                               breakTime: breakTime)
        try! dailyCreateUseCase.execute(model: model) {}
        
        // Act, Assert
        model.title = changeTitle
        do {
            try dailyCreateUseCase.execute(model: model) {}
            XCTAssertEqual(coreDataRepositoryMock.dailyModel?.title, changeTitle)
        } catch {
            XCTFail()
        }
    }
}
