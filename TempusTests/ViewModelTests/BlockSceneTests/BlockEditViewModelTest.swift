//
//  BlockEditViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/27.
//

import XCTest

import RxSwift

final class BlockEditViewModelTest: XCTestCase {
    var repositoryMock: DataManagerRepositoryMock!
    var originModel: BlockModel!
    
    var modelFetchEvent: PublishSubject<Void>!
    var disposeBag: DisposeBag!
    
    var blockEditViewModel: BlockEditViewModel!
    
    var modelTitle: PublishSubject<String>!
    var modelDivideCount: PublishSubject<Int>!
    var completeButtonTapEvent: PublishSubject<Void>!
    
    var editViewModelInput: BlockEditViewModel.Input!
    var editViewModelOutput: BlockEditViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryMock = .init()
        originModel = .init(id: UUID(), title: "testTitle", divideCount: 4)
        
        modelFetchEvent = .init()
        disposeBag = .init()
        
        blockEditViewModel = .init(originModel: originModel,
                                   repository: repositoryMock,
                                   modelFetchEvent: modelFetchEvent)
        
        modelTitle = .init()
        modelDivideCount = .init()
        completeButtonTapEvent = .init()
        
        editViewModelInput = .init(modelTitle: modelTitle,
                                   modelDivideCount: modelDivideCount,
                                   completeButtonTapEvent: completeButtonTapEvent)
        
        editViewModelOutput = blockEditViewModel.transform(input: editViewModelInput,
                                                           disposeBag: disposeBag)
    }
    
    func test_edit_is_success() {
        // Arrange
        let EditSuccessExpectation = XCTestExpectation(description: "edit_is_success_test")
        let changeTitle = "changeTitle"
        let testDivideCount = 4
        
        try! repositoryMock.create(originModel)
        
        editViewModelOutput.isEditSuccess
            .subscribe(onNext: { isEditSuccess in
                if isEditSuccess {
                    EditSuccessExpectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        // Act
        modelTitle.onNext(changeTitle)
        modelDivideCount.onNext(testDivideCount)
        completeButtonTapEvent.onNext(())
        
        // Assert
        wait(for: [EditSuccessExpectation], timeout: 1.0)
        XCTAssertEqual(repositoryMock.blockModel?.title, changeTitle)
    }
}
