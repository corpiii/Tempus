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
    var repositoryFake: DataManagerRepositoryFake!
    
    var modelDeleteEvent: PublishSubject<DailyModel>!
    var modelFetchEvent: PublishSubject<Void>!
    var modelTapEvent: PublishSubject<DailyModel>!
    
    var dailyListViewModel: DailyListViewModel!
    var dailyListViewModelInput: DefaultDailyListViewModel.Input!
    var dailyListViewModelOutput: DefaultDailyListViewModel.Output!
    
    override func setUpWithError() throws {
        disposeBag = .init()
        repositoryFake = .init()
        dailyListViewModel = DefaultDailyListViewModel(repository: repositoryFake)
        
        modelDeleteEvent = .init()
        modelFetchEvent = .init()
        modelTapEvent = .init()
        
        dailyListViewModelInput = .init(addButtonEvent: PublishSubject<Void>(),
                                        modelDeleteEvent: modelDeleteEvent,
                                        modelFetchEvent: modelFetchEvent,
                                        modelTapEvent: modelTapEvent)
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
        
        try! repositoryFake.create(model)
        XCTAssertNotNil(repositoryFake.dailyModel)
        
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
    
    func test_model_delete_is_success() {
        // Arrange
        let fetchExpectation = XCTestExpectation(description: "fetch_is_success")
        let deleteExpectation = XCTestExpectation(description: "delete_is_success")
        let model = DailyModel(id: UUID(),
                               title: "testTitle",
                               startTime: 100,
                               repeatCount: 4,
                               focusTime: 1200,
                               breakTime: 300)
        var resultModels: [DailyModel] = []
        
        try! repositoryFake.create(model)
        XCTAssertNotNil(repositoryFake.dailyModel)
        
        // Act
        dailyListViewModelOutput.dailyModelArray
            .subscribe(onNext: { models in
                resultModels = models
                fetchExpectation.fulfill()
            }).disposed(by: disposeBag)
        
        dailyListViewModelOutput.isDeleteSuccess
            .subscribe(onNext: { result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    XCTFail()
                }
                deleteExpectation.fulfill()
            }).disposed(by: disposeBag)
        
        modelDeleteEvent.onNext(model)
        
        // Assert
        wait(for: [fetchExpectation, deleteExpectation], timeout: 5.0)
        XCTAssertTrue(resultModels.isEmpty)
    }
}
