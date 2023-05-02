//
//  DailyCreateUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/01.
//

import XCTest

import RxSwift

final class DailyCreateUseCaseTest: XCTestCase {
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    var dailyCreateUseCase: DailyCreateUseCase!
    var modelCreateEvent: PublishSubject<DailyModel>!
    var createUseCaseInput: DailyCreateUseCase.Input!
    var createUseCaseOutput: DailyCreateUseCase.Output!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        disposeBag = .init()
        dailyCreateUseCase = DailyCreateUseCase(repository: coreDataRepositoryMock)
        modelCreateEvent = .init()
        createUseCaseInput = .init(modelCreate: modelCreateEvent)
        createUseCaseOutput = dailyCreateUseCase.transform(input: createUseCaseInput, disposeBag: disposeBag)
    }

    func test_Daily_create_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "create_is_success")
        
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
        
        createUseCaseOutput.isCreateSuccess
            .subscribe(onNext: { isCreateSuccess in
                XCTAssertTrue(isCreateSuccess)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        // Act
        modelCreateEvent.onNext(model)
        wait(for: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertNotNil(coreDataRepositoryMock.dailyModel)
    }
}
