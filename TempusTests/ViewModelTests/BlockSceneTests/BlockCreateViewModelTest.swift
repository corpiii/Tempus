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
    var completeEvent: PublishSubject<CompleteAlert>!
    var blockListViewModel: BlockListViewModel!
    
    var blockCreateViewModel: BlockCreateViewModel!
    var disposeBag: DisposeBag!
    var listViewModelInput: BlockListViewModel.Input!
    var listViewModelOutput: BlockListViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryMock = .init()
        completeEvent = .init()
        blockListViewModel = .init(repository: repositoryMock)
        blockCreateViewModel = .init(repository: repositoryMock,
                                     fetchRefreshDelegate: blockListViewModel)
        disposeBag = .init()
        
        listViewModelInput = .init(addButtonEvent: PublishSubject<Void>(),
                                   modelDeleteEvent: PublishSubject<BlockModel>(),
                                   modelFetchEvent: PublishSubject<Void>())
        listViewModelOutput = blockListViewModel.transform(input: listViewModelInput, disposeBag: disposeBag)
    }
    
    func test_create_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "create_is_success_test")
        let modelTitleObservable: PublishSubject<String> = .init()
        let divideCountObservable: PublishSubject<Int> = .init()
        let testTitle = "testTitle"
        let testDivideCount = 4
        
        let input = BlockCreateViewModel.Input(completeButtonTapEvent: completeEvent,
                                               modelTitle: modelTitleObservable,
                                               divideCount: divideCountObservable)
        
        let output = blockCreateViewModel.transform(input: input, disposeBag: disposeBag)
        
        output.isCreateSuccess
            .subscribe(onNext: { isSuccess in
                if isSuccess {
                    expectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        // Act
        modelTitleObservable.onNext(testTitle)
        divideCountObservable.onNext(testDivideCount)
        completeEvent.onNext(.completeWithoutStart)
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(repositoryMock.blockModel?.title, testTitle)
    }
}
