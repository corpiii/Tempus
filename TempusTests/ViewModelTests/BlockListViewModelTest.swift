//
//  BlockListViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/19.
//

import XCTest

import RxSwift

final class BlockListViewModelTest: XCTestCase {
    var blockListViewModel: BlockListViewModel!
    var blockFetchUseCase: BlockFetchUseCase!
    var blockDeleteUseCase: BlockDeleteUseCase!
    var repositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        repositoryMock = DataManagerRepositoryMock()
        blockFetchUseCase = BlockFetchUseCase(repository: repositoryMock)
        blockDeleteUseCase = BlockDeleteUseCase(repository: repositoryMock)
        
        blockListViewModel = BlockListViewModel()
        
        blockListViewModel.blockFetchUseCase = blockFetchUseCase
        blockListViewModel.blockDeleteUseCase = blockDeleteUseCase
        
        disposeBag = DisposeBag()
    }

    func test_fetch_event_emit_then_fetch_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "fetch_event_test_description")
        let testModel = BlockModel(id: UUID(), title: "testTitle", divideCount: 4)
        var resultModel: BlockModel?
        let fetchModelEvent = PublishSubject<Void>()

        try! repositoryMock.create(model: testModel)
        
        let input = BlockFetchUseCase.Input(fetchModelEvent: fetchModelEvent)
        let output = blockFetchUseCase.transform(input: input, disposeBag: disposeBag)
        
        // Act
        output.modelArrayObservable
            .subscribe(onNext: { models in
                resultModel = models.first
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        fetchModelEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 2.0)
        
        if let resultModel {            
            XCTAssertEqual(resultModel.id, testModel.id)
        } else {
            XCTFail("resultModel is nil")
        }
    }

    func test_delete_event_emit_then_fetch_success() {
        // Arrange
        
        // Act
        
        // Assert
    }

}
