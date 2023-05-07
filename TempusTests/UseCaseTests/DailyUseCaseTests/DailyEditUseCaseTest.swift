//
//  DailyEditUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/01.
//

import XCTest

import RxSwift

final class DailyEditUseCaseTest: XCTestCase {
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    
    var dailyEditUseCase: DailyEditUseCase!
    
    var editEvent: PublishSubject<DailyModel>!
    var input: DailyEditUseCase.Input!
    var output: DailyEditUseCase.Output!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        disposeBag = .init()
        
        dailyEditUseCase = .init(repository: coreDataRepositoryMock)

        editEvent = .init()
        input = .init(modelEditEvent: editEvent)
        output = dailyEditUseCase.transform(input: input, disposeBag: disposeBag)
    }

    func test_Daily_edit_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "edit_is_success")
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
        
        try! coreDataRepositoryMock.create(model)
        
        // Act
        output.isEditSuccess
            .subscribe(onNext: { isSuccess in
                XCTAssertTrue(isSuccess)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        model.title = changeTitle
        editEvent.onNext(model)
        
        // Assert
        XCTAssertEqual(coreDataRepositoryMock.dailyModel?.title, changeTitle)
    }
}
