//
//  DailyDeleteUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/02.
//

import XCTest

import RxSwift

final class DailyDeleteUseCaseTest: XCTestCase {
    var repository: DataManagerRepositoryFake!
    var deleteUseCase: DailyDeleteUseCase!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        repository = DataManagerRepositoryFake()
        deleteUseCase = DailyDeleteUseCase(repository: repository)
        disposeBag = .init()
    }
    
    func test_delete_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "delete_test_isSuccess")
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
        try! repository.create(model)
        XCTAssertNotNil(repository.dailyModel)
        
        // Act
        let deleteEvent: PublishSubject<DailyModel> = .init()
        let deleteUseCaseInput = DailyDeleteUseCase.Input(modelDeleteEvent: deleteEvent)
        let deleteUseCaseOutput = deleteUseCase.transform(input: deleteUseCaseInput, disposeBag: disposeBag)
        
        deleteUseCaseOutput.isDeleteSuccess
            .subscribe(onNext: { result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        deleteEvent.onNext(model)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(repository.dailyModel)
    }
    
}
