//
//  BlockListViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/19.
//

import XCTest

import RxSwift

final class BlockListViewModelTest: XCTestCase {
    var repositoryFake: DataManagerRepositoryFake!
    var disposeBag: DisposeBag!
    
    var addButtonTapEvent: PublishSubject<Void>!
    var modelDeleteEvent: PublishSubject<BlockModel>!
    var modelFetchEvent: PublishSubject<Void>!
    var modelTapEvent: PublishSubject<BlockModel>!
    
    var blockListViewModel: BlockListViewModel!
    var blockListViewModelInput: DefaultBlockListViewModel.Input!
    var blockListViewModelOutput: DefaultBlockListViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryFake = DataManagerRepositoryFake()
        disposeBag = DisposeBag()
        
        addButtonTapEvent = .init()
        modelDeleteEvent = .init()
        modelFetchEvent = .init()
        modelTapEvent = .init()
        
        blockListViewModel = DefaultBlockListViewModel(repository: repositoryFake)
        blockListViewModelInput = .init(addButtonEvent: addButtonTapEvent,
                                        modelDeleteEvent: modelDeleteEvent,
                                        modelFetchEvent: modelFetchEvent,
                                        modelTapEvent: modelTapEvent)
        blockListViewModelOutput = blockListViewModel.transform(input: blockListViewModelInput, disposeBag: disposeBag)
    }
    
    func test_fetch_event_emit_then_fetch_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "fetch_event_test_description")
        let testModel = BlockModel(id: UUID(), title: "testTitle", blockTime: 4)
        var resultModel: BlockModel?

        try! repositoryFake.create(testModel)
                
        // Act
        blockListViewModelOutput.blockModelArray
            .subscribe(onNext: { models in
                if !models.isEmpty {
                    resultModel = models.first!
                    expectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
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
        let testModel = BlockModel(id: UUID(), title: "testTitle", blockTime: 4)
        var resultModel: [BlockModel] = []
        
        try! repositoryFake.create(testModel)
        
        // Act
        blockListViewModelOutput.isDeleteSuccess
            .subscribe(onNext: { result in
                if case .success(let model) = result {
                    XCTAssertNotNil(model)
                }
                
                deleteExpectation.fulfill()
            }).disposed(by: disposeBag)
        
        blockListViewModelOutput.blockModelArray
            .subscribe(onNext: { models in
                resultModel = models
                if models.isEmpty {
                    fetchExpectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        modelFetchEvent.onNext(())
        modelDeleteEvent.onNext(testModel)
        
        // Assert
        wait(for: [fetchExpectation, deleteExpectation], timeout: 2.0)
        XCTAssertTrue(resultModel.isEmpty)
    }
}
