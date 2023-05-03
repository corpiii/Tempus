//
//  BlockCreateViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/22.
//

import XCTest

import RxSwift

final class BlockCreateViewModelTest: XCTestCase {
    var repositoryMock: DataManagerRepositoryMock!
    var disposeBag: DisposeBag!
    
    var completeButtonTapEvent: PublishSubject<CompleteAlert>!
    var modelTitle: PublishSubject<String>!
    var divideCount: PublishSubject<Int>!
    
    var fetchRefreshMock: FetchRefreshMock!
    var blockCreateViewModel: BlockCreateViewModel!
    var blockCreateViewModelInput: BlockCreateViewModel.Input!
    var blockCreateViewModelOutput: BlockCreateViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryMock = .init()
        disposeBag = .init()
        
        completeButtonTapEvent = .init()
        modelTitle = .init()
        divideCount = .init()
        
        fetchRefreshMock = .init()
        blockCreateViewModel = .init(repository: repositoryMock,
                                     fetchRefreshDelegate: fetchRefreshMock)
        blockCreateViewModelInput = .init(completeButtonTapEvent: completeButtonTapEvent,
                                          modelTitle: modelTitle,
                                          divideCount: divideCount)
        blockCreateViewModelOutput = blockCreateViewModel.transform(input: blockCreateViewModelInput,
                                                                    disposeBag: disposeBag)
    }
    
    func test_create_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "create_is_success_test")
        let testTitle = "testTitle"
        let testDivideCount = 4
        
        blockCreateViewModelOutput.isCreateSuccess
            .subscribe(onNext: { isSuccess in
                XCTAssertTrue(isSuccess)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        // Act
        modelTitle.onNext(testTitle)
        divideCount.onNext(testDivideCount)
        completeButtonTapEvent.onNext(.completeWithoutStart)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(repositoryMock.blockModel?.title, testTitle)
    }
}
