//
//  BlockEditUseCaseTest.swift
//  TempusTests
//
//  Created by 이정민 on 2023/03/31.
//

import XCTest

import RxSwift

final class BlockEditUseCaseTest: XCTestCase {
    var coreDataRepositoryMock: DataManagerRepositoryMock!
    var blockEditUseCase: BlockEditUseCase!
    
    var modelEditEvent: PublishSubject<BlockModel>!
    var modelFetchEvent: PublishSubject<Void>!
    var disposeBag: DisposeBag!
    
    var editUseCaseInput: BlockEditUseCase.Input!
    var editUseCaseOutput: BlockEditUseCase.Output!
    
    override func setUpWithError() throws {
        coreDataRepositoryMock = DataManagerRepositoryMock()
        blockEditUseCase = BlockEditUseCase(repository: coreDataRepositoryMock)
        
        modelEditEvent = .init()
        modelFetchEvent = .init()
        disposeBag = .init()
        
        editUseCaseInput = .init(modelEditEvent: modelEditEvent, modelFetchEvent: modelFetchEvent)
        editUseCaseOutput = blockEditUseCase.transform(input: editUseCaseInput, disposeBag: disposeBag)
    }

    func test_Block_edit_is_success() {
        // Arrange
        let editSuccessExpectation = XCTestExpectation(description: "edit_success_expectation")
        let id = UUID()
        let title = "testTitle"
        let changeTitle = "changeTitle"
        let divideCount = 6
        
        var model = BlockModel(id: id, title: title, divideCount: divideCount)
        
        try! coreDataRepositoryMock.create(model)
        
        editUseCaseOutput.isEditSuccess
            .subscribe(onNext: { isEditSuccess in
                if isEditSuccess {
                    editSuccessExpectation.fulfill()
                }
            }).disposed(by: disposeBag)
        
        // Act
        model.title = changeTitle
        modelEditEvent.onNext(model)
        
        // Assert
        if let edittedModel = coreDataRepositoryMock.blockModel {
            XCTAssertEqual(edittedModel.id, id)
            XCTAssertEqual(edittedModel.title, changeTitle)
        } else {
            XCTFail()
        }
        
        wait(for: [editSuccessExpectation], timeout: 2.0)
    }
}
