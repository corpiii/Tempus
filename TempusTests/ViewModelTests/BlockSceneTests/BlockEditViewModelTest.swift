//
//  BlockEditViewModelTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/27.
//

import XCTest

import RxSwift

final class BlockEditViewModelTest: XCTestCase {
    var repositoryFake: DataManagerRepositoryFake!
    var originModel: BlockModel!
    var disposeBag: DisposeBag!
    
    var fetchRefreshDummy: FetchRefreshDummy!
    var editReflectDummy: EditReflectDummy!
    
    var modelTitle: PublishSubject<String>!
    var modelBlockTime: PublishSubject<Int>!
    var backButtonTapEvent: PublishSubject<Void>!
    var doneButtonTapEvent: PublishSubject<Void>!
    var completeEvent: PublishSubject<Void>!
    
    var blockEditViewModel: BlockEditViewModel!
    var editViewModelInput: DefaultBlockEditViewModel.Input!
    var editViewModelOutput: DefaultBlockEditViewModel.Output!
    
    override func setUpWithError() throws {
        repositoryFake = .init()
        originModel = .init(id: UUID(), title: "testTitle", blockTime: 4)
        disposeBag = .init()
        
        fetchRefreshDummy = .init()
        editReflectDummy = .init()
        
        modelTitle = .init()
        modelBlockTime = .init()
        backButtonTapEvent = .init()
        doneButtonTapEvent = .init()
        completeEvent = .init()
        
        blockEditViewModel = DefaultBlockEditViewModel(originModel: originModel,
                                   repository: repositoryFake,
                                   fetchRefreshDelegate: fetchRefreshDummy,
                                   editReflectDelegate: editReflectDummy)
        editViewModelInput = .init(modelTitle: modelTitle,
                                   modelBlockTime: modelBlockTime,
                                   doneButtonTapEvent: doneButtonTapEvent,
                                   backButtonTapEvent: backButtonTapEvent,
                                   completeEvent: completeEvent)
        
        editViewModelOutput = blockEditViewModel.transform(input: editViewModelInput,
                                                           disposeBag: disposeBag)
    }
    
    func test_edit_is_success() {
        // Arrange
        let expectation = XCTestExpectation(description: "edit_is_success_test")
        let changeTitle = "changeTitle"
        let testBlockTime = 4
        
        try! repositoryFake.create(originModel)
        
        editViewModelOutput.isEditSuccess
            .subscribe(onNext: { isEditSuccess in
                XCTAssertTrue(isEditSuccess)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        // Act
        modelTitle.onNext(changeTitle)
        modelBlockTime.onNext(testBlockTime)
        doneButtonTapEvent.onNext(())
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(repositoryFake.blockModel?.title, changeTitle)
    }
}
