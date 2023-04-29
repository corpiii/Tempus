//
//  BlockListViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/19.
//

import XCTest

import RxSwift


// createViewModelTests 만들기

final class BlockListViewModelTest: XCTestCase {
    var blockListViewModel: BlockListViewModel!
    var repositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    var addButtonTapEvent: PublishSubject<Void>!
    var modelDeleteEvent: PublishSubject<BlockModel>!
    var modelFetchEvent: PublishSubject<Void>!
    
    override func setUpWithError() throws {
        repositoryMock = DataManagerRepositoryMock()
        blockListViewModel = BlockListViewModel(repository: repositoryMock)
        disposeBag = DisposeBag()
        addButtonTapEvent = .init()
        modelDeleteEvent = .init()
        modelFetchEvent = .init()
    }

    func test_fetch_event_emit_then_fetch_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "fetch_event_test_description")
        let testModel = BlockModel(id: UUID(), title: "testTitle", divideCount: 4)
        var resultModel: BlockModel?

        try! repositoryMock.create(testModel)
        
        let input = BlockListViewModel.Input(addButtonEvent: addButtonTapEvent,
                                             modelDeleteEvent: modelDeleteEvent,
                                             modelFetchEvent: modelFetchEvent)
        
        let output = blockListViewModel.transform(input: input, disposeBag: disposeBag)
        
        output.blockModelArray
            .subscribe(onNext: { models in
                if !models.isEmpty {
                    resultModel = models.first!
                    expectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        // Act
        modelFetchEvent.onNext(())
        wait(for: [expectation], timeout: 2.0)
        
        // Assert
        
        if let resultModel {
            XCTAssertEqual(resultModel.id, testModel.id)
        } else {
            XCTFail("resultModel is nil")
        }
    }

    func test_delete_event_emit_then_fetch_success() {
        // Arrange
        let fetchExpectation = XCTestExpectation(description: "fetch_is_success")
        let deleteExpectation = XCTestExpectation(description: "delete_is_success")
        let testModel = BlockModel(id: UUID(), title: "testTitle", divideCount: 4)
        var resultModel: [BlockModel] = []
        
        let input = BlockListViewModel.Input(addButtonEvent: addButtonTapEvent,
                                             modelDeleteEvent: modelDeleteEvent,
                                             modelFetchEvent: modelFetchEvent)
        
        let output = blockListViewModel.transform(input: input, disposeBag: disposeBag)
        
        output.isDeleteSuccess
            .subscribe(onNext: { isSuccess in
                XCTAssertTrue(isSuccess)
                deleteExpectation.fulfill()
            }).disposed(by: disposeBag)
        
        output.blockModelArray
            .subscribe(onNext: { models in
                resultModel = models
                if models.isEmpty {
                    fetchExpectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        // Act
        try! repositoryMock.create(testModel)
        modelFetchEvent.onNext(())
        modelDeleteEvent.onNext(testModel)
        
        // Assert
        wait(for: [fetchExpectation, deleteExpectation], timeout: 2.0)
        XCTAssertTrue(resultModel.isEmpty)
    }
}
