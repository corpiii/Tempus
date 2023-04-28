//
//  BlockCreateUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/03/31.
//

import XCTest

import RxSwift

final class BlockCreateUseCaseTest: XCTestCase {
    var blockCreateUseCase: BlockCreateUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        blockCreateUseCase = BlockCreateUseCase(repository: coreDataRepositoryMock)
        disposeBag = .init()
    }

    func test_Block_create_is_success() {
        // Arrange
        let id = UUID()
        let title = "testTitle"
        let divideCount = 6
        let model = BlockModel(id: id, title: title, divideCount: divideCount)
        let expectation = XCTestExpectation(description: "block_create_test")
        
        // Act, Assert
        let fetchEvent: PublishSubject<Void> = .init()
        let createEvent: PublishSubject<BlockModel> = .init()
        
        let input = BlockCreateUseCase.Input(modelCreate: createEvent)
        let output = blockCreateUseCase.transform(input: input, disposeBag: disposeBag)
        
        output.isCreateSuccess
            .subscribe(onNext: { [weak self] isSuccess in
                guard let self else { return }
                if isSuccess {
                    XCTAssertEqual(self.coreDataRepositoryMock.blockModel?.id, model.id)
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            }).disposed(by: disposeBag)
        
        createEvent.onNext(model)
        wait(for: [expectation], timeout: 1.0)
    }
}
