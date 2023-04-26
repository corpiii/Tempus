//
//  BlockDeleteUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/01.
//

import XCTest

import RxSwift

final class BlockDeleteUseCaseTest: XCTestCase {
    var blockCreateUseCase: BlockCreateUseCase!
    var blockDeleteUseCase: BlockDeleteUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        blockCreateUseCase = BlockCreateUseCase(repository: coreDataRepositoryMock)
        blockDeleteUseCase = BlockDeleteUseCase(repository: coreDataRepositoryMock)
        disposeBag = .init()
    }

    func test_Block_delete_is_success() {
        // Arrange
        let id = UUID()
        let title = "testTitle"
        let divideCount = 6
        let model = BlockModel(id: id, title: title, divideCount: divideCount)
        let expectation = XCTestExpectation(description: "block_delete_test")
        
        let fetchEvent: PublishSubject<Void> = .init()
        let createEvent: PublishSubject<BlockModel> = .init()
        
        let createInput = BlockCreateUseCase.Input(modelFetchEvent: fetchEvent, modelCreate: createEvent)
        let createOutput = blockCreateUseCase.transform(input: createInput, disposeBag: disposeBag)
        
        createOutput.isCreateSuccess
            .subscribe(onNext: { isSuccess in
                XCTAssertEqual(isSuccess, true)
            }).disposed(by: disposeBag)
        createEvent.onNext(model)
        
        // Act, Assert
        let deleteEvent: PublishSubject<BlockModel> = .init()
        let deleteInput = BlockDeleteUseCase.Input(modelDeleteEvent: deleteEvent, modelFetchEvent: fetchEvent)
        let deleteOutput = blockDeleteUseCase.transform(input: deleteInput, disposeBag: disposeBag)
        
        deleteOutput.isDeleteSuccess
            .subscribe(onNext: { isSuccess in
                XCTAssertEqual(isSuccess, true)
                XCTAssertNil(self.coreDataRepositoryMock.blockModel)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        deleteEvent.onNext(model)
        wait(for: [expectation], timeout: 2.0)
    }
}
