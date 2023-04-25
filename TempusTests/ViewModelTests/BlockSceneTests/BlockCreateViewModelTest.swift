//
//  BlockCreateViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/22.
//

import XCTest

import RxSwift

final class BlockCreateViewModelTest: XCTestCase {
    var blockCreateViewModel: BlockCreateViewModel!
    var repositoryMock: DataManagerRepositoryMock!
    var blockStartUseCase: BlockStartUseCase!
    var modelFetchEvent: PublishSubject<Void>!
    var completeEvent: PublishSubject<CompleteAlert>!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        repositoryMock = .init()
        blockCreateViewModel = .init(repository: repositoryMock)
        modelFetchEvent = .init()
        completeEvent = .init()
        disposeBag = .init()
    }
    
    func test_create_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "create_is_success_test")
        let modelTitleObservable: PublishSubject<String> = .init()
        let divideCountObservable: PublishSubject<Int> = .init()
        let testTitle = "testTitle"
        let testDivideCount = 4
        
        let input = BlockCreateViewModel.Input(completeEvent: completeEvent,
                                               modelTitle: modelTitleObservable,
                                               divideCount: divideCountObservable,
                                               modelFetchEvent: modelFetchEvent)
        
        let output = blockCreateViewModel.transform(input: input, disposeBag: disposeBag)
        
        output.isCreateSucess
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
