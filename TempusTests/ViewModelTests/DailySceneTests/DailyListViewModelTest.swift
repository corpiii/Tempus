//
//  DailyListViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/29.
//

import XCTest

import RxSwift

final class DailyListViewModelTest: XCTestCase {
    var disposeBag: DisposeBag!
    var repositoryMock: DataManagerRepositoryMock!
    var dailyListViewModel: DailyListViewModel!
    var dailyListViewModelInput: DailyListViewModel.Input!
    var dailyListViewModelOutput: DailyListViewModel.Output!
    
    override func setUpWithError() throws {
        disposeBag = .init()
        repositoryMock = .init()
        dailyListViewModel = .init(repository: repositoryMock)
        dailyListViewModelInput = .init(addButtonEvent: PublishSubject<Void>(),
                                        modelDeleteEvent: PublishSubject<DailyModel>(),
                                        modelFetchEvent: PublishSubject<Void>())
        dailyListViewModelOutput = dailyListViewModel.transform(input: dailyListViewModelInput,
                                                                disposeBag: disposeBag)
    }
    
    func test_model_fetch_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "fetch_test_is_success")
        let model = DailyModel(id: UUID(),
                               title: "testTitle",
                               startTime: 100,
                               repeatCount: 4,
                               focusTime: 1200,
                               breakTime: 300)
        var resultModels: [DailyModel] = []
        
        try! repositoryMock.create(model)
        
        // Act
        dailyListViewModelOutput.dailyModelArray
            .subscribe(onNext: { models in
                resultModels = models
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        dailyListViewModelInput.modelFetchEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(resultModels.first?.id, model.id)
    }
}
