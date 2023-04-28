//
//  BlockFetchUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/18.
//

import XCTest

import RxSwift

final class BlockFetchUseCaseTest: XCTestCase {
    var blockFetchUseCase: BlockFetchUseCase!
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        blockFetchUseCase = BlockFetchUseCase(repository: coreDataRepositoryMock)
        disposeBag = DisposeBag()
    }
    
    func test_Block_fetch_is_success() {
        // Arrange
        let id = UUID()
        let title = "testTitle"
        let divideCount = 6
        let model = BlockModel(id: id, title: title, divideCount: divideCount)
        let expectation = XCTestExpectation(description: "fetch_usecase_test")
                
        try! coreDataRepositoryMock.create(model)
        
        // Act, Assert
        let fetchEvent: PublishSubject<Void> = .init()
        let fetchInput = BlockFetchUseCase.Input(modelFetchEvent: fetchEvent)
        let fetchOutput = blockFetchUseCase.transform(input: fetchInput, disposeBag: disposeBag)
        
        fetchOutput.modelArrayObservable
            .subscribe(onNext: { models in
                if !models.isEmpty {
                    XCTAssertEqual(models.first!.id, model.id)
                    expectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        fetchEvent.onNext(())
        
        wait(for: [expectation], timeout: 1.0)
    }
}
