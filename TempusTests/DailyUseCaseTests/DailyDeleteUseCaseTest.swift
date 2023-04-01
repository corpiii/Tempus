//
//  DailyDeleteUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/02.
//

import XCTest

final class DailyDeleteUseCaseTest: XCTestCase {
    var repository: DataManagerRepositoryMock!
    var createUseCase: DailyCreateUseCase!
    var deleteUseCase: DailyDeleteUseCase!
    
    override func setUpWithError() throws {
        repository = DataManagerRepositoryMock()
        createUseCase = DailyCreateUseCase(repository: repository)
        deleteUseCase = DailyDeleteUseCase(repository: repository)
    }
    
    func test_delete_is_success() {
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
        try! createUseCase.execute(model: model) {}
        
        // Act
        do {
            try deleteUseCase.execute(model: model) {}
            XCTAssertNil(repository.dailyModel)
        } catch {
            XCTFail()
        }
        
        // Assert
    }
    
}
