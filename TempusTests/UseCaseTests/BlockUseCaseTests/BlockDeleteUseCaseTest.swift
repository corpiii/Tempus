//
//  BlockDeleteUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/01.
//

import XCTest

import RxSwift

final class BlockDeleteUseCaseTest: XCTestCase {
    var blockDeleteUseCase: BlockDeleteUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
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
        
        
        try! coreDataRepositoryMock.create(model)
        
        // Act
        let deleteEvent: PublishSubject<BlockModel> = .init()
        let deleteInput = BlockDeleteUseCase.Input(modelDeleteEvent: deleteEvent)
        let deleteOutput = blockDeleteUseCase.transform(input: deleteInput, disposeBag: disposeBag)
        
        deleteOutput.isDeleteSuccess
            .subscribe(onNext: { isSuccess in
                XCTAssertTrue(isSuccess)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        deleteEvent.onNext(model)
        
        // Assert
        wait(for: [expectation], timeout: 2.0)
        XCTAssertNil(coreDataRepositoryMock.blockModel)
    }
}
