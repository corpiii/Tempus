//
//  BlockCreateViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/22.
//

import XCTest

import RxSwift

class BlockCreateCoordinatorMock: BlockCreateCoordinator {
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .blockCreate }
    
    func start() { }
    
    func finish(with startUseCase: BlockStartUseCase?) { }
}

final class BlockCreateViewModelTest: XCTestCase {
    var repositoryMock: DataManagerRepositoryFake!
    var disposeBag: DisposeBag!
    
    var modelTitle: PublishSubject<String>!
    var blockTime: PublishSubject<Int>!
    var completeButtonTapEvent: PublishSubject<Void>!
    var cancelButtonTapEvent: PublishSubject<Void>!
    var startButtonTapEvent: PublishSubject<CompleteAlert>!
    
    var fetchRefreshMock: FetchRefreshMock!
    var coordinatorMock: BlockCreateCoordinatorMock!
    
    var blockCreateViewModel: DefaultBlockCreateViewModel!
    var blockCreateViewModelInput: DefaultBlockCreateViewModel.Input!
    var blockCreateViewModelOutput: DefaultBlockCreateViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryMock = .init()
        disposeBag = .init()
        
        modelTitle = .init()
        blockTime = .init()
        completeButtonTapEvent = .init()
        cancelButtonTapEvent = .init()
        startButtonTapEvent = .init()
        
        fetchRefreshMock = .init()
        coordinatorMock = .init()
        blockCreateViewModel = .init(repository: repositoryMock,
                                     fetchRefreshDelegate: fetchRefreshMock)
        blockCreateViewModel.coordinator = coordinatorMock
        
        blockCreateViewModelInput = .init(modelTitle: modelTitle,
                                          modelBlockTime: blockTime,
                                          completeButtonTapEvent: completeButtonTapEvent,
                                          cancelButtonTapEvent: cancelButtonTapEvent,
                                          startEvent: startButtonTapEvent)
        blockCreateViewModelOutput = blockCreateViewModel.transform(input: blockCreateViewModelInput,
                                                                    disposeBag: disposeBag)
    }
    
    func test_create_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "create_is_success_test")
        let testTitle = "testTitle"
        let testBlockTime = 4
        
        // Act
        blockCreateViewModelOutput.isCreateSuccess
            .subscribe(onNext: { isSuccess in
                XCTAssertTrue(isSuccess)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        modelTitle.onNext(testTitle)
        blockTime.onNext(testBlockTime)
        completeButtonTapEvent.onNext(())
        startButtonTapEvent.onNext(.completeWithStart)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(repositoryMock.blockModel?.title, testTitle)
    }
    
    func test_when_given_emptyTitle_then_create_is_failure() {
        // Arrange
        let expectation = XCTestExpectation(description: "create_is_fail_test")
        let testTitle = ""
        let testBlockTime = 2
        
        // Act
        blockCreateViewModelOutput.isCreateSuccess
            .subscribe(onNext: { isSuccess in
                XCTAssertFalse(isSuccess)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        modelTitle.onNext(testTitle)
        blockTime.onNext(testBlockTime)
        completeButtonTapEvent.onNext(())
        startButtonTapEvent.onNext(.completeWithStart)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(repositoryMock.blockModel?.title, nil)
    }
}
