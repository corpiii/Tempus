//
//  DailyFetchUseCaseTests.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/18.
//

import XCTest

import RxSwift

final class DailyFetchUseCaseTests: XCTestCase {
    var dailyFetchUseCase: DailyFetchUseCase!
    var repository: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        repository = DataManagerRepositoryMock()
        dailyFetchUseCase = DailyFetchUseCase(repository: repository)
        disposeBag = .init()
    }
    
    func test_Daily_fetch_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "fetch_test_is_success")
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
        var resultModels: [DailyModel] = []
        
        try! repository.create(model)
        XCTAssertNotNil(repository.dailyModel)
        
        // Act
        let fetchEvent: PublishSubject<Void> = .init()
        let fetchUseCaseInput = DailyFetchUseCase.Input(modelFetchEvent: fetchEvent)
        let fetchUseCaseOutput = dailyFetchUseCase.transform(input: fetchUseCaseInput, disposeBag: disposeBag)
        
        fetchUseCaseOutput.modelArrayObservable
            .subscribe(onNext: { models in
                resultModels = models
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        fetchEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(resultModels.first!.id, id)
    }
}
